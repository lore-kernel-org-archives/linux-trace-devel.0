Return-Path: <SRS0=1j5l=SP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CC34C10F0E
	for <linux-trace-devel@archiver.kernel.org>; Sat, 13 Apr 2019 01:52:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E67420869
	for <linux-trace-devel@archiver.kernel.org>; Sat, 13 Apr 2019 01:52:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H/WN6u7E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbfDMBwf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 21:52:35 -0400
Received: from mail-ua1-f67.google.com ([209.85.222.67]:38391 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbfDMBwf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 21:52:35 -0400
Received: by mail-ua1-f67.google.com with SMTP id t15so3856743uao.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 12 Apr 2019 18:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ley2MiL8l84jX50Dn2h5Czl1aGPEqvnDOuoO900uIzI=;
        b=H/WN6u7ESfScq5rF9An05z++oWff1g6k3o08uD6k6qFEpoOhq5vmMymBr5iPOm0DKN
         MRR+x5UCBxmbCn/+GpDJdjzQWaZDc7cE9EdKU1Z5KQ1m19Jp8ndLxdHEWgxQ2cF8dGDy
         hmjYfotKcxQu3RyvydjrPvEMnjlA+MBDJFYy99u4JKLWlI3s9bWruLL3QEDVXp0g2vtc
         AJf8QbGiksu5mPOmfa65uK/whZkwRFYyieYes0cJogRBSO/tfbhbBMIEz+u5XItOksUh
         P4s/B9E344NapQVUg9RtU83mKqjCUc+JwSS/aIjAzyZe58UD715iyCBNGAFfy4UeJ+XD
         6IMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ley2MiL8l84jX50Dn2h5Czl1aGPEqvnDOuoO900uIzI=;
        b=inpuUFAzltyyMvTOBdCLrKm4MQLd8hcamBgCJXECFVAxOcSWOD7WKxsVD73DHbjyiw
         kRXSes8wxvHh9gNqTyhxRtLpLmxwAl8o99maSHIpyCujJqVH4/SzHBHa9Qv3/8oJpcYT
         QSa+IlF/+XpBF+DLqzrrdLVk5AaLyTSMrtsEo9Ie++61VZFmsSWdEK7v+Mo21rp1jxz6
         wNVKcYyxrx0w5y/RvXhmthPQj7wf65R097uLKmnCn1ZvbFGwXvBGb9SWB2025Ln1P5T3
         SJV1g0yrQ1+uI/72xt+MTQEyzwJKFOmy48M50rgL3SFoG99HtIkGHbIOXTIxG8wbkMMq
         Vdog==
X-Gm-Message-State: APjAAAWO30kK2yAvxNdDrbGFlP29yuY7ztrglRxgTAooB3uBJxvtsqu/
        EE9lbh12dVaDJJ96Ql4Y9BJG34zR+JOpBMTeQNLKvg==
X-Google-Smtp-Source: APXvYqzizaJg/lGulyYWcyU09rFLPAiAQasm0MnzwQVVHHeb6mMq05XYuKlbSWAokic0j84LPkE7A4QMTSU8Lg3uNDs=
X-Received: by 2002:a9f:2c09:: with SMTP id r9mr30586864uaj.56.1555120354009;
 Fri, 12 Apr 2019 18:52:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190408212855.233198-1-joel@joelfernandes.org>
 <CAK7LNAQgvhozubW9b2yqnxHAVE17VHHZiq6N4Py_TzFCHN0YUQ@mail.gmail.com>
 <20190412180014.GA175945@google.com> <CAK7LNAT83SijpivFJA8GS=bOsgfnV03fo+-QJFgO1SgmLBOiQw@mail.gmail.com>
In-Reply-To: <CAK7LNAT83SijpivFJA8GS=bOsgfnV03fo+-QJFgO1SgmLBOiQw@mail.gmail.com>
From:   Daniel Colascione <dancol@google.com>
Date:   Fri, 12 Apr 2019 18:52:22 -0700
Message-ID: <CAKOZueuf8qM1O7c+m7zRHv1b6-YsZmWoTBfErBLY+yV1pyESmQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] Provide in-kernel headers to make extending kernel easier
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     Joel Fernandes <joel@joelfernandes.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        atish patra <atishp04@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Kees Cook <keescook@chromium.org>,
        "Cc: Android Kernel" <kernel-team@android.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Manoj Rao <linux@manojrajarao.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Qais Yousef <qais.yousef@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Shuah Khan <shuah@kernel.org>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Apr 12, 2019 at 6:49 PM Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
>
> On Sat, Apr 13, 2019 at 3:02 AM Joel Fernandes <joel@joelfernandes.org> wrote:
>
> >
> > > > +extern char kernel_headers_data;
> > > > +extern char kernel_headers_data_end;
> > > > +
> > > > +static ssize_t
> > > > +ikheaders_read_current(struct file *file, char __user *buf,
> > >
> > > Could you stretch this line ?
> > > It will still fit in 80-cols.
> > >
> > > (This is a coding style error in kernel/configs.c)
> >
> > It takes 87 cols if I expand, so I'll leave it as is.
> >
>
>
> Sorry if what I said was unclear.
>
> Since I just did not a good reason to put
> "static ssize_t" in the previous line,
> I meant like follows:
>
>
> [Before]
> static ssize_t
> ikheaders_read_current(struct file *file, char __user *buf,
>                        size_t len, loff_t *offset)
>
>
>
> [After]
> static ssize_t ikheaders_read_current(struct file *file, char __user *buf,
>                                       size_t len, loff_t *offset)
>
>
> (takes 74-cols.)
>
>
> (I am sending this from Gmail, so I am not sure
> how it will look like from you...)
>
>
> Anyway, it is super-bikeshedding stuff.
> It is OK as-is.
>

What about sorting the files for determinism?
