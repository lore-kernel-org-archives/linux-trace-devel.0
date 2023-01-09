Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60BC4C5479D
	for <linux-trace-devel@archiver.kernel.org>; Mon,  9 Jan 2023 18:16:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbjAISQ3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 9 Jan 2023 13:16:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237128AbjAISNJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 9 Jan 2023 13:13:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501F56E428
        for <linux-trace-devel@vger.kernel.org>; Mon,  9 Jan 2023 10:10:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0EDA9B80DDE
        for <linux-trace-devel@vger.kernel.org>; Mon,  9 Jan 2023 18:10:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 550D9C433F2;
        Mon,  9 Jan 2023 18:10:32 +0000 (UTC)
Date:   Mon, 9 Jan 2023 13:10:29 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Khem Raj <raj.khem@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] Replace LFS64 interfaces off64_t and lseek64
Message-ID: <20230109131029.4c8b29a3@gandalf.local.home>
In-Reply-To: <20230109130539.62a15985@gandalf.local.home>
References: <20230107010245.1290391-1-raj.khem@gmail.com>
        <20230109130539.62a15985@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 9 Jan 2023 13:05:39 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> > Musl does not define these interfaces unless -D_LARGEFILE64_SOURCE is
> > defined and that too it is transitional until apps switch to using 64bit
> > off_t. We pass -D_LARGEFILE64_SOURCE in makefiles already therefore
> > original lseek and off_t are already 64bit  
> 
> I just tested this, and that's not true.

I left out the headers:

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>

More than needed, but they are my default headers I cut and paste ;-)

-- Steve

> 
> static void pdie(const char *msg)
> {
> 	perror(msg);
> 	exit(-1);
> }

