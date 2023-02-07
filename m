Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED43EC636CC
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Feb 2023 16:18:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbjBGQSJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Feb 2023 11:18:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbjBGQSH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Feb 2023 11:18:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B79B61E296
        for <linux-trace-devel@vger.kernel.org>; Tue,  7 Feb 2023 08:18:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5252360F1F
        for <linux-trace-devel@vger.kernel.org>; Tue,  7 Feb 2023 16:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE19C4339B;
        Tue,  7 Feb 2023 16:18:05 +0000 (UTC)
Date:   Tue, 7 Feb 2023 11:18:03 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v6 0/2] Add initial support for meson
Message-ID: <20230207111803.302dab3e@gandalf.local.home>
In-Reply-To: <20230207154546.zqfq27swtc66ar2v@carbon.lan>
References: <20230207124634.6515-1-dwagner@suse.de>
        <20230207134825.uexdcqlopkuqehuy@carbon.lan>
        <20230207101001.5ef90b44@gandalf.local.home>
        <20230207154546.zqfq27swtc66ar2v@carbon.lan>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 7 Feb 2023 16:45:46 +0100
Daniel Wagner <dwagner@suse.de> wrote:

>   find_path considered the following locations:
> 
>     /usr/local/include/trace-cmd/trace-cmd.h

If you run "pkg-config --cflags libtracecmd" what output does it give you?

-- Steve

>     /usr/include/libtracefs/trace-cmd.h
>     /usr/include/traceevent/trace-cmd.h
>     /home/wagi/work/osc/home:wagi:branches:devel:trace/kernelshark/kernel-shark/trace-cmd.h
>     /home/wagi/bin/trace-cmd.h
>     /home/wagi/.local/bin/trace-cmd.h
>     /home/wagi/node_modules/.bin/trace-cmd.h
>     /home/wagi/work/osc/home:wagi:branches:devel:trace/kernelshark/kernel-shark/usr/local/bin/trace-cmd.h
>     /usr/local/bin/trace-cmd.h
>     /usr/bin/trace-cmd.h
>     /bin/trace-cmd.h
>     /usr/local/include/trace-cmd.h
>     /usr/local/trace-cmd.h
>     /usr/include/trace-cmd.h
>     /usr/trace-cmd.h
>     /include/trace-cmd.h
>     /usr/X11R6/include/trace-cmd.h
>     /usr/X11R6/trace-cmd.h
>     /usr/pkg/include/trace-cmd.h
>     /usr/pkg/trace-cmd.h
>     /opt/include/trace-cmd.h
>     /opt/trace-cmd.h
>     /usr/include/X11/trace-cmd.h

