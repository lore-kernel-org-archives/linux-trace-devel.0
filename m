Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFC03C433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 10:18:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6A506023E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 10:18:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240600AbhDPKSk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 16 Apr 2021 06:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238871AbhDPKSk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 16 Apr 2021 06:18:40 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72CF9C061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 16 Apr 2021 03:18:15 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id v6so40065527ejo.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 16 Apr 2021 03:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Squig9CsBvEFAXlLC8Jmbm9whuxXh9KSeSCeqHab7Ws=;
        b=m0RHubE/yTg8J3udWYhoRofSCtZc4Gl1J8COCyXZktPe5l1NXfJhHRvyCtXNDJ1aJ6
         yJl2tajLvTx6IIs6NjMOb1fIWSe9HdbUb996hQO6TSIV/cQXN1TNHaqrwLgNoB3ncWxE
         8D+PptRMp/Znf+nvmQCqzTLxi38ACxPy4JNTVdLALfqi9Iu61+PGswv10JE+yB+QvJcV
         mqqO5iGWTCK5/G8CSGJCB5yDaI9XJ3RlmnjPB8cxsS/ZwgCnHxjyEZI0fyNCjsgJSyhc
         U1TtsluCt87ha9kszy45eU+4oDCf0e/1zFF1YnDBShbEUgQ0ty7ITGyrMr3TeC44K89T
         vEkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Squig9CsBvEFAXlLC8Jmbm9whuxXh9KSeSCeqHab7Ws=;
        b=Ww5p9vuFJbCNqkDmxbSLnBhJyYkBlNRtU1saPnfeup9bmxU1m6wkEfIVKoGDAhxpBm
         GdRSMP5nicUZG6SkJ+4qO/mBD9pXn8sQ3mEamL4HIvOXkHzuU2Xyt4j91LiABUpdl9gl
         feXm2iToGl8mpvxr7Nn1Z0em3So2Tj4RHOgRf0ht9wm1tdjqqsdpjt7M8IctuHXaGxVi
         n9AFo6hISpwMWXQPhP69adnw7u2FAL6iJdtU4CRTOOnHJ++dVgpjn81LppmudJXchyev
         jAR3+fd9C+ShAVE1OKgC6aslydYAWtqvqenwej3WBaF2draDuUJnNGK9hujwv2Fzi2pY
         c53Q==
X-Gm-Message-State: AOAM530rUYBhNNLnB9HNETmyDQ5Hpv/k9P34LeSppRI+Gw2OFPrn1l0l
        SUPM6tKHzI7MhEO04TTPiR8FdLBUwZgtqw==
X-Google-Smtp-Source: ABdhPJxj++UQE3lWdi7yV5OiAZZmqsqvdG7qjr2AFnt89YuxJvpD2bb96NoDjq+33/OyFFqXxyGTgQ==
X-Received: by 2002:a17:906:4d10:: with SMTP id r16mr7506062eju.169.1618568294193;
        Fri, 16 Apr 2021 03:18:14 -0700 (PDT)
Received: from localhost.localdomain ([151.32.115.237])
        by smtp.gmail.com with ESMTPSA id p3sm3899629ejd.65.2021.04.16.03.18.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Apr 2021 03:18:13 -0700 (PDT)
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Dario Faggioli <dfaggioli@suse.com>
From:   Stefano De Venuto <stefano.devenuto99@gmail.com>
Subject: Combined traces evaluations
Message-ID: <a8576de6-5eae-1e27-173e-4d95b645f6a8@gmail.com>
Date:   Fri, 16 Apr 2021 12:18:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hello,
I'm making some evaluation on tracing events with `trace-cmd agent` and
I noticed that sometimes a match with a kvm_exit event, regarding the
first guest events, doesn't happen.

For example, here the kvm_exit is visible:

           trace.dat: cpus=4
trace-tumbleweed.dat: cpus=1
trace-tumbleweed.dat:            <...>-29155 [000]16777013679205: sched_stat_runtime:   comm=trace-cmd pid=29155 runtime=140813 [ns] vruntime=7024475924876 [ns]
trace-tumbleweed.dat:            <...>-29155 [000]16777013692308: sched_switch:         prev_comm=trace-cmd prev_pid=29155 prev_prio=120 prev_state=S ==> next_comm=trace-cmd next_pid=29157 next_prio=120
trace-tumbleweed.dat:            <...>-29155 [000]16777013696353: write_msr:            c0000100, value 7f515878d740
trace-tumbleweed.dat:            <...>-29157 [000]16777014284180: sched_stat_runtime:   comm=trace-cmd pid=29157 runtime=155889 [ns] vruntime=7024477939951 [ns]
trace-tumbleweed.dat:            <...>-29157 [000]16777014290771: sched_switch:         prev_comm=trace-cmd prev_pid=29157 prev_prio=120 prev_state=S ==> next_comm=yes next_pid=29085 next_prio=120
trace-tumbleweed.dat:            <...>-29157 [000]16777014296815: write_msr:            c0000100, value 7f861456f5c0
           trace.dat:            sleep-7618  [003]16777016549098: sched_process_exec:   filename=/usr/bin/sleep pid=7618 old_pid=7618
           trace.dat:            sleep-7618  [003]16777017486508: write_msr:            c0000100, value 7fd73591f5c0
           trace.dat:     kworker/u8:8-2663  [001]16777017700288: timer_init:           timer=0xffff8a8c84b41098
           trace.dat:     kworker/u8:8-2663  [001]16777017759026: timer_init:           timer=0xffff8a8c84b41398
           trace.dat:     kworker/u8:8-2663  [001]16777017790176: timer_init:           timer=0xffff8a8c84b41698
           trace.dat:     kworker/u8:8-2663  [001]16777017833578: timer_init:           timer=0xffff8a8c84b40198
           trace.dat:     kworker/u8:8-2663  [001]16777017864351: timer_init:           timer=0xffff8a8c84b43198
           trace.dat:     kworker/u8:8-2663  [001]16777017898496: timer_init:           timer=0xffff8a8c84b43498
           trace.dat:     kworker/u8:8-2663  [001]16777017925106: sched_stat_runtime:   comm=kworker/u8:8 pid=2663 runtime=1553944 [ns] vruntime=857719474182 [ns]
           trace.dat:     kworker/u8:8-2663  [001]16777017952596: sched_switch:         prev_comm=kworker/u8:8 prev_pid=2663 prev_prio=120 prev_state=I ==> next_comm=kworker/u8:7 next_pid=2311 next_prio=120
           trace.dat:     kworker/u8:7-2311  [001]16777017968341: sched_stat_runtime:   comm=kworker/u8:7 pid=2311 runtime=11960 [ns] vruntime=857717851510 [ns]
           trace.dat:     kworker/u8:7-2311  [001]16777017979368: sched_switch:         prev_comm=kworker/u8:7 prev_pid=2311 prev_prio=120 prev_state=I ==> next_comm=vhost-1557 next_pid=1608 next_prio=120
           trace.dat:       vhost-1557-1608  [001]16777018016393: sched_waking:         comm=trace-cmd pid=7617 prio=120 target_cpu=001
           trace.dat:       vhost-1557-1608  [001]16777018040762: sched_wakeup:         comm=trace-cmd pid=7617 prio=120 target_cpu=001
           trace.dat:       vhost-1557-1608  [001]16777018057028: kvm_msi_set_irq:      dst 0 vec 59 (Fixed|physical|edge)
           trace.dat:       vhost-1557-1608  [001]16777018064868: kvm_apic_accept_irq:  apicid 0 vec 59 (Fixed|edge)
           trace.dat:       vhost-1557-1608  [001]16777018073306: sched_stat_runtime:   comm=vhost-1557 pid=1608 runtime=15868 [ns] vruntime=8759414247 [ns]
           trace.dat:        CPU 0/KVM-1605  [000]16777018080743: write_msr:            c0011020, value 40000000000000
           trace.dat:       vhost-1557-1608  [001]16777018081984: sched_switch:         prev_comm=vhost-1557 prev_pid=1608 prev_prio=120 prev_state=R ==> next_comm=trace-cmd next_pid=7617 next_prio=120
           trace.dat:       vhost-1557-1608  [001]16777018089488: write_msr:            c0000100, value 7fd41c495740
           trace.dat:        trace-cmd-7617  [001]16777018094601: timer_cancel:         timer=0xffffb253c346bda8
           trace.dat:        CPU 0/KVM-1605  [000]16777018095244: kvm_exit:             vcpu 0 reason interrupt rip 0xffffffffa4000010 info1 0x0000000000000000 info2 0x0000000000000000 intr_info 0x00000000 error_code 0x00000000
           .
           .
           .

But, in this case, this is not:

			trace.dat: cpus=4
trace-tumbleweed.dat: cpus=1
trace-tumbleweed.dat:            <...>-2029  [000]14320154450824: sched_stat_runtime:   comm=trace-cmd pid=2029 runtime=83257 [ns] vruntime=424042595783 [ns]
trace-tumbleweed.dat:            <...>-2029  [000]14320154459784: sched_switch:         prev_comm=trace-cmd prev_pid=2029 prev_prio=120 prev_state=S ==> next_comm=kworker/0:5 next_pid=642 next_prio=120
trace-tumbleweed.dat:            <...>-642   [000]14320154609674: sched_stat_runtime:   comm=kworker/0:5 pid=642 runtime=41065 [ns] vruntime=424037656636 [ns]
trace-tumbleweed.dat:            <...>-642   [000]14320154612824: sched_switch:         prev_comm=kworker/0:5 prev_pid=642 prev_prio=120 prev_state=I ==> next_comm=trace-cmd next_pid=2031 next_prio=120
trace-tumbleweed.dat:            <...>-642   [000]14320154618668: write_msr:            c0000100, value 7ff922cd5740
trace-tumbleweed.dat:            <...>-2031  [000]14320154927909: sched_stat_runtime:   comm=trace-cmd pid=2031 runtime=81803 [ns] vruntime=424042450209 [ns]
trace-tumbleweed.dat:            <...>-2031  [000]14320154935362: sched_switch:         prev_comm=trace-cmd prev_pid=2031 prev_prio=120 prev_state=S ==> next_comm=swapper/0 next_pid=0 next_prio=120
trace-tumbleweed.dat:           <idle>-0     [000]14320155379843: sched_waking:         comm=kworker/0:5 pid=642 prio=120 target_cpu=000
			.
			.
			.
trace-tumbleweed.dat:            <...>-13    [000]14320159278816: write_msr:            c0000100, value 7ff922cd5740
trace-tumbleweed.dat:            <...>-2031  [000]14320159394095: sched_stat_runtime:   comm=trace-cmd pid=2031 runtime=30715 [ns] vruntime=424042602229 [ns]
trace-tumbleweed.dat:            <...>-2031  [000]14320159397210: sched_switch:         prev_comm=trace-cmd prev_pid=2031 prev_prio=120 prev_state=S ==> next_comm=swapper/0 next_pid=0 next_prio=120
           trace.dat:            sleep-6029  [003]14320160638822: timer_init:           timer=0xffff907c44d60798
           trace.dat:            sleep-6029  [003]14320160690679: timer_start:          timer=0xffff907c44a9ac60 function=delayed_work_timer_fn expires=4295807198 [timeout=1] cpu=3 idx=31 flags=D|P|I
           trace.dat:            sleep-6029  [003]14320160700125: sched_stat_runtime:   comm=trace-cmd pid=6029 runtime=593243 [ns] vruntime=257043002407 [ns]
           trace.dat:            sleep-6029  [003]14320160720438: sched_switch:         prev_comm=trace-cmd prev_pid=6029 prev_prio=120 prev_state=D ==> next_comm=swapper/3 next_pid=0 next_prio=120
           trace.dat:           <idle>-0     [002]14320164537024: hrtimer_cancel:       hrtimer=0xffff907d76d21a00
           trace.dat:           <idle>-0     [003]14320164537068: hrtimer_cancel:       hrtimer=0xffff907d76da1a00
           		.
           		.
           		.
           trace.dat:        CPU 0/KVM-1567  [001]14320175237271: kvm_inj_virq:         irq 236
           trace.dat:        CPU 0/KVM-1567  [001]14320175249459: kvm_entry:            vcpu 0, rip 0xffffffff8545200e
           trace.dat:        CPU 0/KVM-1567  [001]14320175253942: write_msr:            c0011020, value 0
trace-tumbleweed.dat:           <idle>-0     [000]14320175283462: hrtimer_cancel:       hrtimer=0xffff9002fdc21a00

In these examples the guest has only one vCPU, so, in the second trace,
a kvm_entry is done before a kvm_exit.

Is there something that I'm missing? What can be the cause of this
mismatch since it only happens at the beginning of the trace?

If necessary, I can provide more info about my setup, or do more tests.

Thanks and Regards,
Stefano
