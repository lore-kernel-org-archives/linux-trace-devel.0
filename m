Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 260FBC6FA8A
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Sep 2022 23:34:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbiIHXeU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Sep 2022 19:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbiIHXdc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Sep 2022 19:33:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B3310043F
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Sep 2022 16:31:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EEC67B822C0
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Sep 2022 23:30:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F02C433D6;
        Thu,  8 Sep 2022 23:30:38 +0000 (UTC)
Date:   Thu, 8 Sep 2022 19:31:20 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtracefs: Add API to set custom tracing directory
Message-ID: <20220908193120.7a85549e@gandalf.local.home>
In-Reply-To: <20220826054212.146976-1-tz.stoyanov@gmail.com>
References: <20220826054212.146976-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 26 Aug 2022 08:42:12 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Usually the system's tracing directory is mounted as a subfolder in
> /sys/kernel and is auto detected by the tracefs library, using the
> information from the "/proc/mounts" file. But there are cases where
> /sys and /proc are mounted inside a container on a custom mount point.
> In those cases the tracefs library cannot auto detect the system's
> tracing directory. That's why a new API is introduced, to handle these
> custom use cases:
>  int tracefs_set_tracing_dir(char *tracing_dir);
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>

Applied. Thanks Tzvetomir!

-- Steve
