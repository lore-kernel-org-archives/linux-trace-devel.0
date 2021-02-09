Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24E4AC433E0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Feb 2021 06:05:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCEC964EC2
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Feb 2021 06:05:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhBIGEx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Feb 2021 01:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbhBIGEw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Feb 2021 01:04:52 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036FDC061786
        for <linux-trace-devel@vger.kernel.org>; Mon,  8 Feb 2021 22:04:09 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id o63so11802819pgo.6
        for <linux-trace-devel@vger.kernel.org>; Mon, 08 Feb 2021 22:04:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5Kd1lDHCiAF98CiKZBp4iQk3zvvnIAKdKFsMUU17YXc=;
        b=D6zlWw34Zty5pCL+6EHjDWB6WGcudGcsfOMwG6XSXrgNpiXsGcr6tb5jEG/mcZWh/O
         FpeNCgN8OZ21NLeuBGHzODHzgFMTD75kNVhtPV9JVTiOh3P+eMMpPZJgRixKCBNFFJFZ
         IzyhOhV1pFmtPpxoD+DnF4l6ZgyCPWikdsoNw3iZQ+od/miHV/q5JCAre3XGukrUMU1t
         7UthvPvfLJ6xVZQr6It0Twkms15M74hJodMGL2IE3ryV4j2KaqgTU3Z8JrelKnPXQId0
         IASnLOCv1RKFlU4UaRcNKBXC+/eANmcPFqPW7OXoJgyMfXKcdxXO+ILqGeeVq5ZAqxUE
         2hKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5Kd1lDHCiAF98CiKZBp4iQk3zvvnIAKdKFsMUU17YXc=;
        b=j7og/xRwMGLQZb06hisUXPRpRVEesGWyie6YOWiq2zvf+/Wsf9JTu3zhvCzq2dRwiC
         idybQV7UgIPrzRPhOo9wCXGQ7qTNRPLcZI1XN/SwBQrNpJV/sOC9EfkROdAKdmhwzAQ+
         eGjnToqvw2BMmxL3bqtl4jmQLu1wlmw6tpQfVw4wdJR2CFBsCCc0JJiMjQw2yWO0B4/A
         2t4SDpipgaCfVX+9KGF1aJ30VCj/gFYWghrof2w0nUAuVDAgIy8k7QC+nxuZKilDE5Et
         fspNezYSeVvst2B3z4jcchi3jJn/N8WKwQunulIH/KO5BCje1PX0MCmwJ3HEa36EuYM8
         CkFA==
X-Gm-Message-State: AOAM533y60aoV+f3Z1nDq/fcAESglr89GCe44Dz73xU7QJbTAj6+Lzwp
        TmHEqDzbiqOnjpp2I5AH39b6VMxcwHqd+70Eo4oMsfCkQJvAlw==
X-Google-Smtp-Source: ABdhPJy923GSvc4PGP3gVIhHq1LyAi2O3RoY+yAqH54tNHFJDf/ownpn7aSrWFpVyc0ZXOLFJv3NJFKn11eg23/5HDM=
X-Received: by 2002:a05:6a00:148a:b029:1ae:6d20:fbb3 with SMTP id
 v10-20020a056a00148ab02901ae6d20fbb3mr20503625pfu.55.1612850648450; Mon, 08
 Feb 2021 22:04:08 -0800 (PST)
MIME-Version: 1.0
References: <20210208061743.510964-1-tz.stoyanov@gmail.com> <bb09f02e5d1e14cf835c85c97ae7902976bdb408.camel@suse.com>
In-Reply-To: <bb09f02e5d1e14cf835c85c97ae7902976bdb408.camel@suse.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 9 Feb 2021 08:03:52 +0200
Message-ID: <CAPpZLN5SQu=XwQ+XodbVWrXUb-qtcLjH-U79R6NBDJ4jwQSvsw@mail.gmail.com>
Subject: Re: [PATCH v28 0/8] Timestamp synchronization of host - guest tracing session
To:     Dario Faggioli <dfaggioli@suse.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Dario,

On Tue, Feb 9, 2021 at 7:32 AM Dario Faggioli <dfaggioli@suse.com> wrote:
>
> Hello,
>
> On Mon, 2021-02-08 at 08:17 +0200, Tzvetomir Stoyanov (VMware) wrote:
> > Basic infrastructure for host - guest timestamp synchronization and a
> > PoC implementation of PTP-like and KVM algorithms.
> >
> I'm trying to play with trace-cmd agent & clock syncronization, so I
> applied this series.
>
> However, when I try to connect to a VM where I have the agent running,
> I'm seeing this (on the host):
>
> # ./tracecmd/trace-cmd record --debug -p nop -e sched:* -e kvm:* -e timer:hrtimer* -A tumbleweed-jeos:8888 -e all sleep 1
> trace-cmd: No such file or directory
>   Failed to receive trace response -107
>
> I tried to do a strace, still on the host, and this is what I see (the
> last part of the output):
>
> rt_sigaction(SIGINT, {sa_handler=0x4116a5, sa_mask=[INT], sa_flags=SA_RESTORER|SA_RESTART, sa_restorer=0x7f29f1b55b70}, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
> openat(AT_FDCWD, "/var/lib/trace-cmd/virt/(null)/trace-pipe-cpu0.out", O_RDONLY|O_NONBLOCK) = -1 ENOENT (No such file or directory)
> socket(AF_VSOCK, SOCK_STREAM, 0)        = 4
> connect(4, {sa_family=AF_VSOCK, sa_data="\0\0\270\"\0\0\3\0\0\0\0\0\0\0"}, 16) = 0
> openat(AT_FDCWD, "/sys/kernel/debug/tracing/trace_clock", O_RDONLY) = 6
> read(6, "local global counter uptime perf"..., 8192) = 62
> read(6, "", 8192)                       = 0
> close(6)                                = 0
> write(4, "\0\0\0<\0\0\0\6\0\0\0\20\0\0\0\0\0\0\0\0\347\366+n\204\271\35\334", 28) = 28
> write(4, "\0\0\0\0\0\0\0\v\0\0\0\2-e\0all\0\0\0\0\1\0\0\0\5ptp\0\0", 32) = 32
> read(4, "", 12)                         = 0
> dup(2)                                  = 6
> fcntl(6, F_GETFL)                       = 0x402 (flags O_RDWR|O_APPEND)
> fstat(6, {st_mode=S_IFCHR|0620, st_rdev=makedev(0x88, 0x9), ...}) = 0
> write(6, "trace-cmd: No such file or direc"..., 37trace-cmd: No such file or directory
> ) = 37
> close(6)                                = 0
> write(2, "  ", 2  )                       = 2
> write(2, "Failed to receive trace response"..., 37Failed to receive trace response -107) = 37
> write(2, "\n", 1
> )                       = 1
> exit_group(2)                           = ?
> +++ exited with 2 +++
>
> Finally, if I use `--debug` both on the host and in the VM, here's what
> I get.
>
> Guest:
> # ./tracecmd/trace-cmd agent -p 8888 --debug
> listening on @3:8888
> msg received: 6 (TRACE_REQ) [60]
> Segmentation fault
>
> Host:
> # ./tracecmd/trace-cmd record --debug -p nop -e sched:* -e kvm:* -e timer:hrtimer* -A tumbleweed-jeos:8888 -e all sleep 1
> msg send: 6 (TRACE_REQ) [60]
> trace-cmd: No such file or directory
>   Failed to receive trace response -107
>
> Am I doing something wrong? :-)
>
> If necessary, I can provide more info about my setup, or do more tests.

There are a few limitations that we are working to address:
 1. Ensure that vhost_vsock module is loaded on the host.
 2. You should add a vsock device manually to your VM config, I use
"virsh edit <vm name>" to add:
   <vsock model='virtio'>
      <cid auto='yes'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x09'
function='0x0'/>
    </vsock>
somewhere in the <devices> </devices> section.

>
> Thanks and Regards
> --
> Dario Faggioli, Ph.D
> http://about.me/dario.faggioli
> Virtualization Software Engineer
> SUSE Labs, SUSE https://www.suse.com/
> -------------------------------------------------------------------
> <<This happens because _I_ choose it to happen!>> (Raistlin Majere)



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
