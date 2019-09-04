Return-Path: <SRS0=sqOa=W7=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A597C3A5A7
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Sep 2019 11:50:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F37C022CF7
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Sep 2019 11:50:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbfIDLuk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Sep 2019 07:50:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:32918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726010AbfIDLuk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Sep 2019 07:50:40 -0400
Received: from oasis.local.home (bl11-233-114.dsl.telepac.pt [85.244.233.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 469B020820;
        Wed,  4 Sep 2019 11:50:38 +0000 (UTC)
Date:   Wed, 4 Sep 2019 07:50:31 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Uhanov, Kirill" <kirill.uhanov@intel.com>
Cc:     "'linux-trace-devel@vger.kernel.org'" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] tools lib trace-cmd: Fix typo with file descriptors
 conditions.
Message-ID: <20190904075031.447f0532@oasis.local.home>
In-Reply-To: <E9875C329132824C9E8D827BD6069E125C64F045@irsmsx110.ger.corp.intel.com>
References: <E9875C329132824C9E8D827BD6069E125C64F045@irsmsx110.ger.corp.intel.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 4 Sep 2019 10:48:37 +0000
"Uhanov, Kirill" <kirill.uhanov@intel.com> wrote:

Hmm, Patchwork doesn't want to pick this up. Probably because of the
strange mime format that your mail client is using. I'll send this
patch for you (using a From line for you). But if you want to
contribute to Linux related projects, it may be a good idea to work
with other intel developers to fix your mail client such that patches
work as inlined.

Thanks!

-- Steve


> tools lib trace-cmd: Fix typo with file descriptor conditions
> 
> Signed-off-by: Kirill Uhanov <kirill.uhanov@intel.com>
> 
> 
> 
> diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
> 
> index 0bd0657..650b259 100644
> 
> --- a/lib/trace-cmd/trace-recorder.c
> 
> +++ b/lib/trace-cmd/trace-recorder.c
> 
> @@ -244,7 +244,7 @@ tracecmd_create_buffer_recorder_maxkb(const char *file, int cpu, unsigned flags,
> 
>                              goto out;
> 
>                fd2 = open(file2, O_RDWR | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
> 
> -              if (fd < 0)
> 
> +             if (fd2 < 0)
> 
>                              goto err;
> 
>                recorder = tracecmd_create_buffer_recorder_fd2(fd, fd2, cpu, flags, buffer, maxkb);
> 
> 
> 
> --------------------------------------------------------------------
> Joint Stock Company Intel A/O
> Registered legal address: Krylatsky Hills Business Park,
> 17 Krylatskaya Str., Bldg 4, Moscow 121614,
> Russian Federation
> 
> This e-mail and any attachments may contain confidential material for
> the sole use of the intended recipient(s). Any review or distribution
> by others is strictly prohibited. If you are not the intended
> recipient, please contact the sender and delete all copies.

