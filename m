Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E0E5C76196
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Mar 2023 16:56:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbjCMQ4u (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Mar 2023 12:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbjCMQ4s (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Mar 2023 12:56:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127B376F4A
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Mar 2023 09:56:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E75A6134F
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Mar 2023 16:56:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CF4FC4339C;
        Mon, 13 Mar 2023 16:56:30 +0000 (UTC)
Date:   Mon, 13 Mar 2023 12:56:28 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        John 'Warthog9' Hawley <warthog9@kernel.org>
Subject: Re: _sockaddr still not working?
Message-ID: <20230313125628.12ac6c3a@gandalf.local.home>
In-Reply-To: <AE6938E5-462C-40D2-8DB2-97704DF40093@oracle.com>
References: <AE6938E5-462C-40D2-8DB2-97704DF40093@oracle.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 13 Mar 2023 15:23:42 +0000
Chuck Lever III <chuck.lever@oracle.com> wrote:

> Sorry to be a squeaky wheel, but I've got a system running Fedora 37 latest and the _sockaddr trace macros still are not working:
> 
> 
>           <idle>-0     [004]  1016.727319: svc_xprt_enqueue:     [FAILED TO PARSE] server=ARRAY[02, 00, 08, 01, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00] client=<CE>mn flags=0x4c83 netns_ino=4026531840 pid=1302
>             nfsd-1302  [005]  1016.727358: svc_xprt_dequeue:     [FAILED TO PARSE] server=ARRAY[02, 00, 08, 01, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00] client=<88><AC>K flags=0x4c83 netns_ino=4026531840 wakeup=0x2d
>             nfsd-1302  [005]  1016.727513: svcsock_new_socket:   type=STREAM family=AF_INET
>             nfsd-1302  [005]  1016.727526: svc_xprt_enqueue:     [FAILED TO PARSE] server=ARRAY[02, 00, 08, 01, c0, a8, 01, 33, 00, 00, 00, 00, 00, 00, 00, 00] client=ARRAY[02, 00, 02, bc, c0, a8, 01, c6, 00, 00, 00, 00, 00, 00, 00, 00] flags=0x4819 netns_ino=4026531840 pid=1300
>             nfsd-1302  [005]  1016.727529: svc_xprt_accept:      [FAILED TO PARSE] server=ARRAY[02, 00, 08, 01, c0, a8, 01, 33, 00, 00, 00, 00, 00, 00, 00, 00] client=ARRAY[02, 00, 02, bc, c0, a8, 01, c6, 00, 00, 00, 00, 00, 00, 00, 00] flags=0x4819 netns_ino=4026531840 protocol=tcp service=nfsd
> 
> These tracepoints are no good until _sockaddr fields can be parsed by user space tooling on everyday distributions.
> 

I believe libtraceevent 1.7.1 handles this. I'm guessing that you are asking
for Fedora to supply this.

John, are you still maintaining this package for Fedora?

I use Debian, and it looks to be at 1.7.1.

-- Steve
