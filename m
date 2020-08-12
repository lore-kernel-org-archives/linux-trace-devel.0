Return-Path: <SRS0=GzmE=BW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A66EDC433DF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Aug 2020 09:46:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 773A9206DA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Aug 2020 09:46:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OO5p/UmZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgHLJqu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 Aug 2020 05:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbgHLJqt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 Aug 2020 05:46:49 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B23BFC06174A;
        Wed, 12 Aug 2020 02:46:49 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id a79so741420pfa.8;
        Wed, 12 Aug 2020 02:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j9DqocFSRZqh3/32LzTb32Gf6cEtsoyUborGw0BEqqk=;
        b=OO5p/UmZgSZBmYjacgYgA2pVRpJdRNF8oURaNnHxXLR/pGPj8wOP4lj2qiFCCIMttW
         E51ARyiSYr1eStCFpK2qOS6JESIxEOT5Py5GLAlwkEHpBHH69WmZzOmHnvWUcxhmLLOH
         WZHMN3ttI+gCblLHDGPjLcAVABNVeAKv5N1K7Je2iPIV4yI+0T4bEcp8S2IQ3LsEwSs+
         McyCoqH5V0i+fEPixFEGSNBGOFcscy07BW53n1FD9AMyixWAFrJkJ87DsQmife5kART3
         QhFZ41HXSyeEgO72+Jn0mM/pUmHwU2VypGlAm6deh46iFV0que2WN6WmDdw/GD9JQAfi
         C6PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j9DqocFSRZqh3/32LzTb32Gf6cEtsoyUborGw0BEqqk=;
        b=rvhcY2/6tMKc+TxXj2lcECXUHEkAmbMS29SlKw1p+H/VLac9lMsqpusTKDxnq2Df5a
         dqEShAX+FuP6vjtkIHWLEqnQTB06K/yzKcUNvdQfZ+9Vp7F5lyfZfHm2HP0RCnkE2XZI
         7IuZKglFsZIanu87vCYT9KEQsh4hUQeVycae7vrxvyUgTaJ9yBHrXJuFLxYgxU8SpMXa
         m4MIgF0z39mP54cZFarOpfxWpIiVgEQlGZ83bsfypZiSlF5fpSYoObjvL8O5Ir/PYr1I
         UWIDWe9rP08YDIMKJ/qBjejAgvsiA/UlSky59c92yo6eAB49dTycFadTqgnwnVQyVhmv
         iEvQ==
X-Gm-Message-State: AOAM530PKn659lOt5RyMsC6eC9XJXKxqFN/G/Xnvz6rfGcv9JEF8KeBf
        Z9nUF05mlnKTsd9qNgRPBKeB+33X/RlbYXLm3MYJXIU+NchQWQ==
X-Google-Smtp-Source: ABdhPJzD3V3OtnZKBOOB0HWGDjiAumtQrTvUvWEmjw9t9GMPBKJN42b2yKVemi10fT1oYmmc4JKurRkQAzBzXbmkgmc=
X-Received: by 2002:aa7:96db:: with SMTP id h27mr10173597pfq.26.1597225608941;
 Wed, 12 Aug 2020 02:46:48 -0700 (PDT)
MIME-Version: 1.0
References: <CANczwAGy1tQe1yhgnwhfStGCfh4iFvMei_AqPEvTbLmmPBWatg@mail.gmail.com>
 <20200811205411.2f7748ac@oasis.local.home>
In-Reply-To: <20200811205411.2f7748ac@oasis.local.home>
From:   Ahmed Zaki <anzaki@gmail.com>
Date:   Wed, 12 Aug 2020 11:46:12 +0200
Message-ID: <CANczwAFqvuCnG1hf3qeu-aH=eiyBM9JZJVGJPec+crkzpLZ02Q@mail.gmail.com>
Subject: Re: function_profile_enabled not showing Time info
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-users@vger.kernel.org,
        linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 12 Aug 2020 at 02:54, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 12 Aug 2020 00:35:24 +0200
> Ahmed Zaki <anzaki@gmail.com> wrote:
>
> > Hello,
> >
> > I am trying to use function_profile_enabled on a MIPS machine but only
> > the HITS column is showing numbers. Time and Avg are showing all
> > Zeros.
>
> What clock are you using?
>
>  cat /sys/kernel/debug/tracing/trace_clock
>
> And also supply the dmesg output, so I can see if there's an issue with
> the clock being used.
>
> -- Steve
>
>
> >
> > This is my .config file:
> >
> > CONFIG_FTRACE=y
> > CONFIG_FUNCTION_TRACER=y
> > CONFIG_FUNCTION_GRAPH_TRACER=y
> > CONFIG_IRQSOFF_TRACER=y
> > CONFIG_SCHED_TRACER=y
> > CONFIG_DYNAMIC_FTRACE=y
> >
> > Am I missing something?
> >
> > Thanks.
>

# cat /sys/kernel/debug/tracing/trace_clock
[local] global counter uptime perf mono mono_raw boot

I tried all of them and still getting zeros in TIme and Avg

And below is dmesg, thanks.

[    0.000000] Linux version 4.14.171 (ahmed@ahmed-VirtualBox) (gcc
version 5.4.0 (Buildroot 2017.02.4-g3e5f6d5bc-dirty)) #1 Tue Aug 11
13:52:20 MDT 2020
[    0.000000] bootconsole [early0] enabled
[    0.000000] CPU0 revision is: 00019750 (MIPS 74Kc)
[    0.000000] MIPS: machine is UBNT-UAP-AC-M
[    0.000000] SoC: Qualcomm Atheros QCA956X ver 1 rev 0
[    0.000000] Determined physical RAM map:
[    0.000000]  memory: 08000000 @ 00000000 (usable)
[    0.000000] Primary instruction cache 64kB, VIPT, 4-way, linesize 32 bytes.
[    0.000000] Primary data cache 32kB, 4-way, VIPT, cache aliases,
linesize 32 bytes
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x0000000000000000-0x0000000007ffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000000000-0x0000000007ffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000000000-0x0000000007ffffff]
[    0.000000] On node 0 totalpages: 32768
[    0.000000] free_area_init_node: node 0, pgdat 80640220,
node_mem_map 81007540
[    0.000000]   Normal zone: 256 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 32768 pages, LIFO batch:7
[    0.000000] random: get_random_bytes called from
start_kernel+0xa0/0x47c with crng_init=0
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 32512
[    0.000000] Kernel command line: console=ttyS0,115200n8 rootfstype=jffs2
[    0.000000] PID hash table entries: 512 (order: -1, 2048 bytes)
[    0.000000] Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
[    0.000000] Writing ErrCtl register=00000000
[    0.000000] Readback ErrCtl register=00000000
[    0.000000] Memory: 121536K/131072K available (4158K kernel code,
261K rwdata, 1616K rodata, 1380K init, 525K bss, 9536K reserved, 0K
cma-reserved)
[    0.000000] SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] ftrace: allocating 15925 entries in 32 pages
[    0.000000] NR_IRQS: 51
[    0.000000] CPU clock: 775.000 MHz
[    0.000000] clocksource: MIPS: mask: 0xffffffff max_cycles:
0xffffffff, max_idle_ns: 4932285024 ns
[    0.000007] sched_clock: 32 bits at 387MHz, resolution 2ns, wraps
every 5541893118ns
[    0.008231] Calibrating delay loop... 385.02 BogoMIPS (lpj=192512)
[    0.025759] pid_max: default: 32768 minimum: 301
[    0.030890] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.037891] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.049414] clocksource: jiffies: mask: 0xffffffff max_cycles:
0xffffffff, max_idle_ns: 1911260446275000 ns
[    0.059741] futex hash table entries: 256 (order: 0, 7168 bytes)
[    0.066201] pinctrl core: initialized pinctrl subsystem
[    0.072820] NET: Registered protocol family 16
[    0.084554] PCI host bridge /ahb/pcie-controller@18250000 ranges:
[    0.091038]  MEM 0x0000000012000000..0x0000000013ffffff
[    0.096559]   IO 0x0000000000000000..0x0000000000000000
[    0.122978] PCI host bridge to bus 0000:00
[    0.127348] pci_bus 0000:00: root bus resource [mem 0x12000000-0x13ffffff]
[    0.134602] pci_bus 0000:00: root bus resource [io  0x0000]
[    0.140485] pci_bus 0000:00: root bus resource [??? 0x00000000 flags 0x0]
[    0.147649] pci_bus 0000:00: No busn resource found for root bus,
will use [bus 00-ff]
[    0.156043] pci 0000:00:00.0: [168c:003c] type 00 class 0x028000
[    0.156102] pci 0000:00:00.0: reg 0x10: [mem 0x00000000-0x001fffff 64bit]
[    0.156158] pci 0000:00:00.0: reg 0x30: [mem 0x00000000-0x0000ffff pref]
[    0.156240] pci 0000:00:00.0: supports D1
[    0.156249] pci 0000:00:00.0: PME# supported from D0 D1 D3hot
[    0.156456] pci_bus 0000:00: busn_res: [bus 00-ff] end is updated to 00
[    0.156482] pci 0000:00:00.0: BAR 0: assigned [mem
0x12000000-0x121fffff 64bit]
[    0.164244] pci 0000:00:00.0: BAR 6: assigned [mem
0x12200000-0x1220ffff pref]
[    0.172461] clocksource: Switched to clocksource MIPS
[    0.217220] NET: Registered protocol family 2
[    0.222606] TCP established hash table entries: 1024 (order: 0, 4096 bytes)
[    0.230012] TCP bind hash table entries: 1024 (order: 2, 20480 bytes)
[    0.236904] TCP: Hash tables configured (established 1024 bind 1024)
[    0.243771] UDP hash table entries: 256 (order: 1, 12288 bytes)
[    0.250128] UDP-Lite hash table entries: 256 (order: 1, 12288 bytes)
[    0.257157] NET: Registered protocol family 1
[    0.261846] PCI: CLS 0 bytes, default 32
[    0.268183] workingset: timestamp_bits=30 max_order=15 bucket_order=0
[    0.279278] jffs2: version 2.2 (NAND) (SUMMARY) (LZMA)
(CMODE_PRIORITY) (c) 2001-2006 Red Hat, Inc.
[    0.299629] io scheduler noop registered
[    0.303803] io scheduler deadline registered (default)
[    0.310903] pinctrl-single 1804002c.pinmux: 544 pins at pa b804002c size 68
[    0.319276] Serial: 8250/16550 driver, 1 ports, IRQ sharing disabled
[    0.326750] console [ttyS0] disabled
[    0.330606] 18020000.uart: ttyS0 at MMIO 0x18020000 (irq = 9,
base_baud = 1562500) is a 16550A
[    0.339719] console [ttyS0] enabled
[    0.347287] bootconsole [early0] disabled
[    0.362510] m25p80 spi0.0: mx25l12805d (16384 Kbytes)
[    0.367804] 5 fixed-partitions partitions found on MTD device spi0.0
[    0.374384] Creating 5 MTD partitions on "spi0.0":
[    0.379357] 0x000000000000-0x000000060000 : "u-boot"
[    0.385291] 0x000000060000-0x000000070000 : "u-boot-env"
[    0.391662] 0x000000070000-0x000000f70000 : "firmware"
[    0.401096] 2 uimage-fw partitions found on MTD device firmware
[    0.407258] Creating 2 MTD partitions on "firmware":
[    0.412409] 0x000000000000-0x000000200000 : "kernel"
[    0.418280] 0x000000200000-0x000000f00000 : "rootfs"
[    0.424167] mtd: device 4 (rootfs) set to be root filesystem
[    0.430107] 0x000000f70000-0x000000ff0000 : "cfg"
[    0.435786] 0x000000ff0000-0x000001000000 : "art"
[    0.442294] libphy: Fixed MDIO Bus: probed
[    0.530457] random: fast init done
[    1.071833] libphy: ag71xx_mdio: probed
[    1.131902] ag71xx 19000000.eth: connected to PHY at mdio-bus.0:04
[uid=004dd074, driver=Atheros 8031 ethernet]
[    1.142955] eth0: Atheros AG71xx at 0xb9000000, irq 4, mode: sgmii
[    1.150433] Netfilter messages via NETLINK v0.30.
[    1.155670] nf_conntrack version 0.5.0 (2048 buckets, 8192 max)
[    1.162775] NET: Registered protocol family 10
[    1.171904] Segment Routing with IPv6
[    1.175834] NET: Registered protocol family 17
[    1.180555] Bridge firewalling registered
[    1.184733] 8021q: 802.1Q VLAN Support v1.8
[    4.259284] jffs2: notice: (1) jffs2_build_xattr_subsystem:
complete building xattr subsystem, 0 of xdatum (0 unchecked, 0 orphan)
and 0 of xref (0 dead, 0 orphan) found.
[    4.275688] VFS: Mounted root (jffs2 filesystem) readonly on device 31:4.
[    4.301258] Freeing unused kernel memory: 1380K
[    4.305970] This architecture does not have kernel memory protection.
[    5.310549] jffs2: notice: (308) jffs2_build_xattr_subsystem:
complete building xattr subsystem, 0 of xdatum (0 unchecked, 0 orphan)
and 0 of xref (0 dead, 0 orphan) found.
[    6.330613] random: dd: uninitialized urandom read (512 bytes read)
[    6.525170] random: avahi-daemon: uninitialized urandom read (4 bytes read)
[    6.547278] random: avahi-daemon: uninitialized urandom read (4 bytes read)
[   13.699503] random: crng init done
[   14.526615] Loading modules backported from Linux version
v4.19.98-0-gd183c8e2647a
[   14.534488] Backport generated by backports.git v4.19.98-1-0-g8204eb99
[   18.071321] PCI: Enabling device 0000:00:00.0 (0000 -> 0002)
[   18.077401] ath10k_pci 0000:00:00.0: pci irq legacy oper_irq_mode 1
irq_mode 0 reset_mode 0
[   18.253583] ath10k_pci 0000:00:00.0: Direct firmware load for
ath10k/pre-cal-pci-0000:00:00.0.bin failed with error -2
[   18.264673] ath10k_pci 0000:00:00.0: Falling back to user helper
[   18.282503] ath10k_pci 0000:00:00.0: Direct firmware load for
ath10k/QCA988X/hw2.0/firmware-6.bin failed with error -2
[   18.293580] ath10k_pci 0000:00:00.0: Falling back to user helper
[   18.564289] ath10k_pci 0000:00:00.0: qca988x hw2.0 target
0x4100016c chip_id 0x043222ff sub 0000:0000
[   18.573883] ath10k_pci 0000:00:00.0: kconfig debug 1 debugfs 1
tracing 1 dfs 0 testmode 0
[   18.587016] ath10k_pci 0000:00:00.0: firmware ver 10.2.4.70.70 api
5 features no-p2p,raw-mode,mfp,allows-mesh-bcast crc32 3a226daa
[   18.663342] ath10k_pci 0000:00:00.0: Direct firmware load for
ath10k/QCA988X/hw2.0/board-2.bin failed with error -2
[   18.674165] ath10k_pci 0000:00:00.0: Falling back to user helper
[   18.692404] ath10k_pci 0000:00:00.0: board_file api 1 bmi_id N/A
crc32 bebc7c08
[   19.742442] ath10k_pci 0000:00:00.0: htt-ver 2.1 wmi-op 5 htt-op 2
cal file max-sta 128 raw 0 hwcrypto 1
[   19.833153] ath: EEPROM regdomain: 0x0
[   19.833164] ath: EEPROM indicates default country code should be used
[   19.833168] ath: doing EEPROM country->regdmn map search
[   19.833181] ath: country maps to regdmn code: 0x3a
[   19.833186] ath: Country alpha2 being used: US
[   19.833190] ath: Regpair used: 0x3a
[   20.758095] ath: EEPROM regdomain: 0x0
[   20.758106] ath: EEPROM indicates default country code should be used
[   20.758110] ath: doing EEPROM country->regdmn map search
[   20.758125] ath: country maps to regdmn code: 0x3a
[   20.758130] ath: Country alpha2 being used: US
[   20.758134] ath: Regpair used: 0x3a
