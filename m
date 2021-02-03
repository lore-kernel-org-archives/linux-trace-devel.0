Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 574C7C433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Feb 2021 20:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0CBB64F6C
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Feb 2021 20:22:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbhBCUV5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Feb 2021 15:21:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:49636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231194AbhBCUV4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Feb 2021 15:21:56 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A829364F41;
        Wed,  3 Feb 2021 20:21:15 +0000 (UTC)
Date:   Wed, 3 Feb 2021 15:21:14 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v27 5/5] trace-cmd [POC]: Add KVM timestamp
 synchronization plugin
Message-ID: <20210203152114.4ea7674c@gandalf.local.home>
In-Reply-To: <20210201160339.506562-6-tz.stoyanov@gmail.com>
References: <20210201160339.506562-1-tz.stoyanov@gmail.com>
        <20210201160339.506562-6-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon,  1 Feb 2021 18:03:39 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +++ b/lib/trace-cmd/trace-timesync-kvm.c
> @@ -0,0 +1,460 @@
> +// SPDX-License-Identifier: LGPL-2.1
> +/*
> + * Copyright (C) 2020, VMware, Tzvetomir Stoyanov tz.stoyanov@gmail.com>
> + *
> + */
> +
> +#include <fcntl.h>
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <sys/stat.h>
> +#include <dirent.h>
> +
> +#include "trace-cmd.h"
> +#include "trace-cmd-private.h"
> +#include "tracefs.h"
> +#include "trace-tsync-local.h"
> +
> +#define KVM_DEBUG_FS "/sys/kernel/debug/kvm"
> +#define KVM_DEBUG_OFFSET_FILE	"tsc-offset"
> +#define KVM_DEBUG_SCALING_FILE	"tsc-scaling-ratio"
> +#define KVM_DEBUG_VCPU_DIR	"vcpu"
> +
> +#define KVM_SYNC_PKT_REQUEST	1
> +#define KVM_SYNC_PKT_RESPONSE	2
> +
> +typedef __s64 s64;
> +

I have the same issue with __s64 on the one machine. Best to use:

 typdef long long s64;

-- Steve
