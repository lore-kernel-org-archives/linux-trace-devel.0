Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 903D2C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Nov 2021 03:39:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbhKWDmU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Nov 2021 22:42:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:42256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229948AbhKWDmT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Nov 2021 22:42:19 -0500
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31C4760FBF;
        Tue, 23 Nov 2021 03:39:11 +0000 (UTC)
Date:   Mon, 22 Nov 2021 22:39:09 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Beau Belgrave <beaub@linux.microsoft.com>,
        linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH] libtraceevent: Add __rel_loc relative location
 attribute support
Message-ID: <20211122223909.15f6fb50@rorschach.local.home>
In-Reply-To: <163757381684.511392.14804088833440960833.stgit@devnote2>
References: <163757380763.511392.6830680420693577369.stgit@devnote2>
        <163757381684.511392.14804088833440960833.stgit@devnote2>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 22 Nov 2021 18:36:57 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> @@ -3886,6 +3900,8 @@ static inline void dynamic_offset_field(struct tep_handle *tep,
>  					unsigned int *len)
>  {
>  	dynamic_offset(tep, field->size, data + field->offset, offset, len);
> +	if (field->flags & TEP_FIELD_IS_RELATIVE)
> +		offset += field->offset + field->size;

I think you want *offset += field->offset + field->size;

-- Steve

>  }
>  
