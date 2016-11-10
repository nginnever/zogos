package main

import (
        "bufio"
        "fmt"
        "io"
        "os"
        "os/exec"
        "regexp"
        "time"
)

var prog string
var stratum = "stratum+tcp://us1-zcash.flypool.org:3333"

var homedir string

func init() {
        homedir = os.Getenv("HOME")
        prog = homedir + "/github/test/silentarmy/silentarmy"
}

func writeLog(msg string) {
        fi, err := os.OpenFile(homedir+"/Desktop/miner.log", os.O_APPEND|os.O_WRONLY|os.O_CREATE, 0666)
        if err != nil {
                fmt.Println("BAD PROBLEM: ", err)
                return
        }
        defer fi.Close()

        fmt.Fprintf(fi, "%s: %s\n", time.Now(), msg)
        fi.Sync()
}

func reboot() {
        cmd := exec.Command(homedir+"/./tryagain")
        cmd.Run()
}

func main() {
        dead := regexp.MustCompile("dev[0-9] 0.0")
        addr := os.Args[1]
        gpus := os.Args[2]
        name := os.Args[3]

        cmd := exec.Command(prog, "--use", gpus, "-c", stratum, "-u", addr+"."+name)
        start := time.Now()

        p, err := cmd.StdoutPipe()
        if err != nil {
                panic(err)
        }

        serr, err := cmd.StderrPipe()
        if err != nil {
                panic(err)
        }

        go io.Copy(os.Stderr, serr)

        writeLog("starting miner")
        err = cmd.Start()
        if err != nil {
                panic(err)
        }

        scan := bufio.NewScanner(p)
        for scan.Scan() {
                fmt.Println(">", scan.Text())
                if time.Since(start) > time.Second*300 &&
                        dead.MatchString(scan.Text()) {
                        writeLog("detected dead GPU Rebooting!")
                        time.Sleep(time.Second)
                        reboot()
                }
        }
}
