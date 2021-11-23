Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DC3CC433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Nov 2021 12:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234758AbhKWMIy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Nov 2021 07:08:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:44130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232545AbhKWMIy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Nov 2021 07:08:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 701DA61002;
        Tue, 23 Nov 2021 12:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637669146;
        bh=fTGOdijPPVdw9d2mo8sxZg8iVhJhMRLQ35jUABAEUJ0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JqNM92MfqPrUcvjGmVgw9fBjAnii335pYpIZ0SfhJ8IX0HYb3UZVlVfD088YhkC73
         BQbOp3ombRUfsWgmoiSYEYQl7wsDtMKXg8l6bI+7RlKPWory3CgkD1DSx0ozbsScYF
         u2m5Lznixn6srWqKFTPWUSGqBbjmAzbmASoEQBjbOZtH+ZHrV/nu3nBP/cXQlc+VhT
         4LYewQLvp1YPbfqCMKT7cHV5/TxysdIiTiYsyLS90HHwX6b4hnN/PDy/MkHMu6bmYa
         LrvkLKKuFpi8Hfhr4tMSrtDHgqs1d/RxjMvrZ5Gw8aFWo0M6dsOHr2/FB5LzMHXGz3
         MV74IbK1Jc0yg==
Date:   Tue, 23 Nov 2021 21:05:43 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Beau Belgrave <beaub@linux.microsoft.com>,
        linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH] libtraceevent: Add __rel_loc relative location
 attribute support
Message-Id: <20211123210543.06fed832b5ab3af31a789592@kernel.org>
In-Reply-To: <20211122223909.15f6fb50@rorschach.local.home>
References: <163757380763.511392.6830680420693577369.stgit@devnote2>
        <163757381684.511392.14804088833440960833.stgit@devnote2>
        <20211122223909.15f6fb50@rorschach.local.home>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 22 Nov 2021 22:39:09 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 22 Nov 2021 18:36:57 +0900
> Masami Hiramatsu <mhiramat@kernel.org> wrote:
> 
> > @@ -3886,6 +3900,8 @@ static inline void dynamic_offset_field(struct tep_handle *tep,
> >  					unsigned int *len)
> >  {
> >  	dynamic_offset(tep, field->size, data + field->offset, offset, len);
> > +	if (field->flags & TEP_FIELD_IS_RELATIVE)
> > +		offset += field->offset + field->size;
> 
> I think you want *offset += field->offset + field->size;

Oops, good catch! Yes, that's right.

BTW, are there any tool I can use for testing this library?

Thank you,

> 
> -- Steve
> 
> >  }
> >  


-- 
Masami Hiramatsu <mhiramat@kernel.org>
