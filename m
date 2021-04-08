Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37D50C433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 13:22:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2671610CA
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 13:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhDHNWV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 09:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbhDHNWU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 09:22:20 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADBC3C061760
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Apr 2021 06:22:09 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id q10so1406120pgj.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 08 Apr 2021 06:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4qzE2/6ZMPLABueC2fU4vctTpcJ81xWO/QGtkZTc3nc=;
        b=lpe3P7pZ/UZ4jopcgC0NE2Yifw2uegrwr/onsM/ha3wUyNGZCaFAX7sQoNR6SvQssx
         Sj3lLWx4UY/We8aPTFAJnpS1eskgomMAQznPK/xwpUQYbwewHTJjUDiByOYD2Hv+1w+U
         HyXCMqjtT5ohcbvqnnaHFUpkMiVQi+cVAsxvoEVcjWiga5JCcbQAffhGfun+sUmPkklk
         0hSFej2hcKvGPs8+xM+SGBC1plHZXr4kKLM/TL6WRlSWGP+rUweraTFZx9o80jHNysIV
         jLL2uAHaEZKbb/AxC+IdIlFvd9meThVRII2bL8nTu9XDLsiltlNae1IcoxX7Qz+6yrdb
         /qJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4qzE2/6ZMPLABueC2fU4vctTpcJ81xWO/QGtkZTc3nc=;
        b=QkLVUS/BiSn3iUldfj6gesDa/X7zO+Iw4d6l2ihSNRBvtspzEzkRAJ72ww9Z+TOVUd
         6Uh2Mb55u13kbGZK0Po5i4p62C7c+gmQ7YiIVmtbxaV5SJ/jdLkSTJKw0ZB68zY9nVrS
         Ul1YwvG12MN8Eog9H5QCd36f4fqiTmvRu+727L9kngXncwpzPtAg/rxkMhLO2Gg8MCyA
         HaLn9p1JGXrqaZlHUxKFj5MkMUlsrln/8h3xHM5TW03l+U+zukRUMUBw5ko3X1DVDk4R
         iyyod92FyLSMjdKrsxbx05tNs6vyTOBMk5I0cHlnKUteUmd3rHheSwXh4glwIG43OiqS
         uiVA==
X-Gm-Message-State: AOAM532cxetaGUvRur0L6AksP1mT6s6yWm5YbZASKzWsaHgoC8mJDvTc
        jn6ZaoQJGopJasnDGJHZ4q1E6DYwasbpEns2n/3vvJNHHZbnFQ==
X-Google-Smtp-Source: ABdhPJxmfqaGJIxSuwI6OIt5kILhqbnbF/FTDa5HcELgN6X/YuKQ5616Jk9UPlq276nUZcXRSHfhV4WOYPkNjt4CT4c=
X-Received: by 2002:a65:47ca:: with SMTP id f10mr8167379pgs.206.1617888129265;
 Thu, 08 Apr 2021 06:22:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210408080821.3129896-1-tz.stoyanov@gmail.com> <20210408085935.77e2fd4e@gandalf.local.home>
In-Reply-To: <20210408085935.77e2fd4e@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 8 Apr 2021 16:21:52 +0300
Message-ID: <CAPpZLN7-H536pJxU1ovn6L_wGzmFOzXtVngdWrcSwH+LQvRVdw@mail.gmail.com>
Subject: Re: [PATCH v2] libtracefs: Add new API for open trace marker file
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Apr 8, 2021 at 3:59 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu,  8 Apr 2021 11:08:21 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > Added new APIs for opening trace_marker file of given instance:
> >    tracefs_marker_init()
> >    tracefs_marker_write()
> >    tracefs_marker_vprint()
> >    tracefs_marker_print()
> >    tracefs_marker_close()
>
> I really don't like the name as it's more about the tracefs implementation
> and not what it's used for. I much rather have:
>
>         tracefs_print_init();
>         tracefs_printf();
>         tracefs_vprintf();
>         tracefs_print_close();
>
> And you should never write binary into the trace_marker file, as it always
> expects ascii strings. That's the trace_marker_raw file. In which case we
> could have:
>
>         tracefs_binary_init();
>         tracefs_binary_write();
>         tracefs_binary_close();
>
> For binary writes.
>
I find "tracefs_print_" a little bit confusing, like printing
something on console. I think the name should stress that a user
string/data is written in the trace buffer. I would like to combine
string and binary APIs into one set, something like:

 tracefs_user_trace_init();  /* open both trace_marker and
trace_marker_raw files, or have flags to specify what file to open,
string or data*/
 tracefs_user_trace_printf(); /* write to  trace_marker */
 tracefs_user_trace_vprintf(); /* write to  trace_marker */
 tracefs_user_trace_binary(); /* write to  trace_marker_raw */
 tracefs_user_trace_init(); /* close both string and data fd, if open */


> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
