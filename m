Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBE16ECAAD3
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Sep 2022 18:30:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbiIISa7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Sep 2022 14:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiIISa6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Sep 2022 14:30:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F8EA99F6
        for <linux-trace-devel@vger.kernel.org>; Fri,  9 Sep 2022 11:30:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D248C620A4
        for <linux-trace-devel@vger.kernel.org>; Fri,  9 Sep 2022 18:30:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 073FEC433D6;
        Fri,  9 Sep 2022 18:30:55 +0000 (UTC)
Date:   Fri, 9 Sep 2022 14:31:39 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtraceevent: Add processing of __get_sockaddr() and
 __get_sockaddr_rel()
Message-ID: <20220909143139.20a65f46@gandalf.local.home>
In-Reply-To: <0BB398D4-F990-4875-B222-47826788836B@oracle.com>
References: <20220628122350.434ec8df@gandalf.local.home>
        <0BB398D4-F990-4875-B222-47826788836B@oracle.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 9 Sep 2022 18:00:45 +0000
Chuck Lever III <chuck.lever@oracle.com> wrote:


> This is a freshly-updated Fedora 36 system running v6.0-rc4,
> and the __sockaddr stuff still doesn't work.
> 
>        mount.nfs-1639  [002]   406.390138: svc_xprt_enqueue:     [FAILED TO PARSE] server=ARRAY[02, 00, 8a, 97, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00] client=<E8>sl flags=0x4c03 netns_ino=4026531840 pid=0
>        mount.nfs-1639  [002]   406.390360: svcsock_new_socket:   type=STREAM family=AF_INET6 (listener)
>        mount.nfs-1639  [002]   406.390361: svc_xprt_enqueue:     [FAILED TO PARSE] server=ARRAY[0a, 00, a7, e7, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00] client=*<FC>% flags=0x4c03 netns_ino=4026531840 pid=0
>        mount.nfs-1639  [002]   406.390439: rpc_task_begin:       task:00000002@00000002 flags=DYNAMIC|NO_ROUND_ROBIN|SOFT|TIMEOUT|NORTO|CRED_NOREF runstate=ACTIVE status=0 action=0x0
>        mount.nfs-1639  [002]   406.390440: rpc_task_run_action:  task:00000002@00000002 flags=DYNAMIC|NO_ROUND_ROBIN|SOFT|TIMEOUT|NORTO|CRED_NOREF runstate=RUNNING|ACTIVE status=0 action=call_start
>        mount.nfs-1639  [002]   406.390440: rpc_request:          task:00000002@00000002 nfsv4 SETCLIENTID (sync)
>   NFSv4 callback-1642  [006]   406.390440: svc_xprt_dequeue:     [FAILED TO PARSE] server=ARRAY[02, 00, 8a, 97, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00] client=<CA>d^F flags=0x4c83 netns_ino=4026531840 wakeup=0x18325fae
> 
> # dnf list libtrace\*
> Last metadata expiration check: 1:27:00 ago on Fri 09 Sep 2022 12:31:57 PM EDT.
> Installed Packages
> libtracecmd.x86_64                         1.1.3-2.fc36                 @updates
> libtraceevent.x86_64                       1.5.3-2.fc36                 @updates
> libtracefs.x86_64                          1.3.1-2.fc36                 @updates
> Available Packages
> libtracecmd.i686                           1.1.0-3.fc36                 fedora  
> libtracecmd-devel.i686                     1.1.0-3.fc36                 fedora  
> libtracecmd-devel.x86_64                   1.1.3-2.fc36                 updates 
> libtraceevent.i686                         1.5.3-2.fc36                 updates 
> libtraceevent-devel.i686                   1.5.3-2.fc36                 updates 
> libtraceevent-devel.x86_64                 1.5.3-2.fc36                 updates 

That parsing was added in libtraceevent 1.6.2.

-- Steve

> libtracefs.i686                            1.3.1-2.fc36                 updates 
> libtracefs-devel.i686                      1.3.1-2.fc36                 updates 
> libtracefs-devel.x86_64                    1.3.1-2.fc36                 updates 
