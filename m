Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C638FC4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 19:15:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A35AB610A5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 19:15:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbhHSTP6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Aug 2021 15:15:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:54750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234126AbhHSTP5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 15:15:57 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D84CA604DC;
        Thu, 19 Aug 2021 19:15:20 +0000 (UTC)
Date:   Thu, 19 Aug 2021 15:15:14 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 50/87] trace-cmd library: Read compression header
Message-ID: <20210819151514.6d63f431@oasis.local.home>
In-Reply-To: <20210729050959.12263-51-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
        <20210729050959.12263-51-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 29 Jul 2021 08:09:22 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> @@ -3752,11 +3755,38 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
>  	handle->total_file_size = lseek64(handle->fd, 0, SEEK_END);
>  	lseek64(handle->fd, offset, SEEK_SET);
>  
> +	if (handle->file_version >= 7) {

In the next version, remove all comparisons to 7, and create feature
flags. Then in one place, where the version is decided on, it will set
the feature flags that are supported by that version. And everyplace
else, references the features, not the number. Because 7 is really
meaningless, and years from now, will just cause more confusion.

-- Steve


> +		zname = read_string(handle);
> +		if (!zname)
> +			goto failed_read;
> +		zver = read_string(handle);
> +		if (!zver)
> +			goto failed_read;
> +		if (strcmp(zname, "none")) {
