Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CD4BC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Nov 2021 04:32:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0015361AA3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Nov 2021 04:32:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242979AbhKREfh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Nov 2021 23:35:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233419AbhKREff (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Nov 2021 23:35:35 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DFDAC061570
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Nov 2021 20:32:35 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id r23so4162442pgu.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Nov 2021 20:32:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CRNu/BZzY/P+ECyysSLohvlr4h5Wj71kMuclR7S6WRA=;
        b=aF8ALL0lKDDwxHBqTrNLwqIbLSv8TwfFxCn7TqwbgCAy6Mua9f9x5HbsCZq28S+ILK
         fLD1RDaxXwXZsqOcxndfHv704tybyHCATZ3YY1+GndXw3UIjgHGcA9hH+7bH3im07q3l
         LYbfbVFJqYO6UQihPBrXNdfP0Lv8Sk22L7Y6jlY8BIwOuHLbpXVBDRqBpHzd8hYcdnE3
         PrjM1yFA2yL5j3MtfPooHYve7B/VfqAkfw1t6pIn1sKkGSdeghqrsvPuJy6cBz4J3vXf
         F6iWJLDBY/Pq/YucN9nodcmI/4iQOSf+I+hpJRW2Y3KQIUMbU9GQwkiT4yj2/rNRoAbq
         w/Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CRNu/BZzY/P+ECyysSLohvlr4h5Wj71kMuclR7S6WRA=;
        b=JsCsLwM3Izs4a1PB/KqFFMuRGj+x/Sk/YnMb+wyc6nz/0nzjuTAJ0lIprtpkxyA4E3
         yUUJmUTL/5R39Rcjwdl7HGRtVKjqwrcRT7VzTdIG8DTsP+9m4IYexdqDKdT7AtE3j0p3
         OXYhsVOyKPjovt1gFCFro/0bmKtLty3b27jV6wD/fKHWqaajsL36H09fMouY4b+R0q57
         tljj3uxCSgy7hL7CkD1uKjEeLEz6o/P0Mbf6mWkwahHom19X73TN1ZSdDNb1S9W3Bp0Q
         gl7nZmhZT90b4Cb57dz6NZr/h8CtUUogf156tI9UD8Xfb/PRNHzh4haCU4mZuwaW+TIO
         YuxA==
X-Gm-Message-State: AOAM531uWbkSG+XIzbjJYWbmqmzCm/ns0I7ZAnj6p1cVFlDYtDr6DlvX
        pNFQiOyz0YnT2EzioeiNakUdGG4JVCdZoLM4juImR21Ltl49Xw==
X-Google-Smtp-Source: ABdhPJxh2CH9hFuIE7QLeEVvp/bG7lOnMDaV3zv5h0//AHlZODxLG9Vi4g7dTDKvuVgX6xGE4IBtQrAyJBNFvBcvWHM=
X-Received: by 2002:aa7:8883:0:b0:49f:f87a:95de with SMTP id
 z3-20020aa78883000000b0049ff87a95demr53319406pfe.53.1637209955032; Wed, 17
 Nov 2021 20:32:35 -0800 (PST)
MIME-Version: 1.0
References: <20211117154101.38659-1-tz.stoyanov@gmail.com> <20211117154101.38659-2-tz.stoyanov@gmail.com>
 <20211117131757.6209091b@gandalf.local.home>
In-Reply-To: <20211117131757.6209091b@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 18 Nov 2021 06:32:18 +0200
Message-ID: <CAPpZLN7_GU-+0=OjVpL58fyGKVJtsY6qq-QRLgyfP0QdQkepuQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] [RFC] trace: Page size per ring buffer
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Nov 17, 2021 at 8:18 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
[ ... ]
> > +static int release_header_file(struct inode *inode, struct file *file)
> > +{
> > +     struct trace_array *tr = inode->i_private;
> > +
> > +     trace_array_put(tr);
> > +
> > +     return 0;
> > +}
> > +
>
> Why add these and not just use:
>
> tracing_open_generic_tr() and tracing_release_generic()?
>
> Where the latter would need to become global to use.
>

This is another leftover of a previous version of that implementation
- I used inode->i_private to pass the buffer and filp->private_data to
pass the pointer to the function that should be called. That way the
same show_header_page_file() can be used for both "header_page" and
"header_event" files. But for that approach I had to change the
definition of ring_buffer_print_entry_header(), to be the same as
ring_buffer_print_page_header(). It would have an additional
trace_buffer input parameter that is not used. That's why decided to
have different "show_header_.." functions and not to touch
ring_buffer_print_entry_header().

>
> >  static ssize_t
> > -show_header(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
> > +show_header_page_file(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
> >  {
> > -     int (*func)(struct trace_seq *s) = filp->private_data;
> > +     struct trace_array *tr = file_inode(filp)->i_private;
>
> Then you also do not need to use the file_inode macro, because the
> tracing_open_generic_tr() will set filp->private_data to it.
>
> -- Steve
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
