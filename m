Return-Path: <SRS0=o1/+=W2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52A39C3A59B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Aug 2019 21:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AEA22343B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Aug 2019 21:44:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728159AbfH3Vog convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 30 Aug 2019 17:44:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728157AbfH3Vog (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 30 Aug 2019 17:44:36 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B8FB2343A;
        Fri, 30 Aug 2019 21:44:35 +0000 (UTC)
Date:   Fri, 30 Aug 2019 17:44:34 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Uhanov, Kirill" <kirill.uhanov@intel.com>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: trace-recorder.c patch
Message-ID: <20190830174434.223f6c37@gandalf.local.home>
In-Reply-To: <E9875C329132824C9E8D827BD6069E125C6241A7@irsmsx110.ger.corp.intel.com>
References: <E9875C329132824C9E8D827BD6069E125C6241A7@irsmsx110.ger.corp.intel.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Hi Kirill,

We try to follow the Linux kernel method of sending patches. You can
read that here:

  https://www.kernel.org/doc/html/v4.17/process/submitting-patches.html

If you only want to add this one fix and do not plan on sending other
fixes (thus you may not care about the formal process), at a minimum we
need you to add a:

 "Signed-off-by: Your Name <your-email>"

This is described in section 11 "Sign your work - the Developer’s
Certificate of Origin" of the above link.

Thanks!

-- Steve


On Thu, 15 Aug 2019 15:13:28 +0000
"Uhanov, Kirill" <kirill.uhanov@intel.com> wrote:

> Hi All.
> 
> Looks like some typo in lib/trace-cmd/trace-recorder.c
> 
> Could you apply patch?
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
> -             if (fd < 0)
> 
> +             if (fd2 < 0)
> 
>                              goto err;
> 
>                recorder = tracecmd_create_buffer_recorder_fd2(fd, fd2, cpu, flags, buffer, maxkb);
> 
> Thanks, Kirill
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

