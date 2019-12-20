Return-Path: <SRS0=9eMf=2K=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9F60C43603
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Dec 2019 03:25:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F3E524680
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Dec 2019 03:25:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfLTDZj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Dec 2019 22:25:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:34130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726964AbfLTDZj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Dec 2019 22:25:39 -0500
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F13724680;
        Fri, 20 Dec 2019 03:25:38 +0000 (UTC)
Date:   Thu, 19 Dec 2019 22:25:36 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/6] trace-cmd: Introduce libtracefs library
Message-ID: <20191219222536.0080b3b8@rorschach.local.home>
In-Reply-To: <20191219113502.28964-2-tz.stoyanov@gmail.com>
References: <20191219113502.28964-1-tz.stoyanov@gmail.com>
        <20191219113502.28964-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.4git76 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 19 Dec 2019 13:34:57 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> diff --git a/lib/tracefs/tracefs-utils.c b/lib/tracefs/tracefs-utils.c
> new file mode 100644
> index 0000000..c695b8b
> --- /dev/null
> +++ b/lib/tracefs/tracefs-utils.c
> @@ -0,0 +1,180 @@
> +// SPDX-License-Identifier: LGPL-2.1
> +/*
> + * Copyright (C) 2019, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>

Just an FYI. If you create a file with code moved from other files, the
new file must keep the same copyright as the code it came from. Which
in this case it would be:

 * Copyright (C) 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>

You can then add:

 * Updates:
 *   Copyright (C) 2019, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>

This goes for any file that is created with code from other files.

-- Steve


> + *
> + */
> +#include <stdlib.h>
> +#include <sys/mount.h>
> +#include <sys/stat.h>
> +#include <linux/limits.h>
