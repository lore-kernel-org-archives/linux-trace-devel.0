Return-Path: <SRS0=1j5l=SP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C369C10F0E
	for <linux-trace-devel@archiver.kernel.org>; Sat, 13 Apr 2019 01:49:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D06120869
	for <linux-trace-devel@archiver.kernel.org>; Sat, 13 Apr 2019 01:49:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="rX02K2pP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbfDMBtG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 21:49:06 -0400
Received: from conssluserg-02.nifty.com ([210.131.2.81]:63412 "EHLO
        conssluserg-02.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbfDMBtG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 21:49:06 -0400
Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169]) (authenticated)
        by conssluserg-02.nifty.com with ESMTP id x3D1mwOp005573;
        Sat, 13 Apr 2019 10:48:59 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-02.nifty.com x3D1mwOp005573
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1555120139;
        bh=O9oYvxK5r7nd0a5Qx5tmpDK2z46KhkmD2c6StVwobOI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=rX02K2pPey6MLOBNniUHUhEepaFoLTpXkPW6jOqnfnhIgdH8uEY/at/4IsGUmLd4S
         pzNTQpvr4IxzTr7QObRJb55oTvArpMkM+tfM/kLnLAAF8K150BZaeOVTd1O6XOXFGS
         jufu1QPalN2xbwOwx9EA5gPaQn7pSQfOWDD4rVcQy2smBujGNO0LD66yBhbuR6VSnU
         6V7igM59A6dEtF23lLgMqrBB65z77mNpkJjQuyZY6T1AV/97qUdWlgoga6NmTvWjTA
         bhpGdflFkc+nTA9biRGga+4UNfmWE7Gp5ggo6APnyYPPgC/yjOKaTBIv+13RvwUn0D
         7BJVxbEA6Uq5w==
X-Nifty-SrcIP: [209.85.221.169]
Received: by mail-vk1-f169.google.com with SMTP id h71so2560605vkf.5;
        Fri, 12 Apr 2019 18:48:58 -0700 (PDT)
X-Gm-Message-State: APjAAAVdQACJ+rVUzApltem6X9r6L5rjCTwH1HGoqQ11DNKE2FMCAyPQ
        eIbun5ZauJjbBdaqHOGVIlFm3UjEjNxTffzCQhc=
X-Google-Smtp-Source: APXvYqy3a6EW/rvEeRuVqGeMRTgJ3IxHSp31a9jvTjXxX6KZJKnc3dfv/qPtGxEnspXN/DVN7GxmktJeUmz6Ub8QeC4=
X-Received: by 2002:a1f:39c:: with SMTP id f28mr33679288vki.19.1555120137746;
 Fri, 12 Apr 2019 18:48:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190408212855.233198-1-joel@joelfernandes.org>
 <CAK7LNAQgvhozubW9b2yqnxHAVE17VHHZiq6N4Py_TzFCHN0YUQ@mail.gmail.com> <20190412180014.GA175945@google.com>
In-Reply-To: <20190412180014.GA175945@google.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Sat, 13 Apr 2019 10:48:21 +0900
X-Gmail-Original-Message-ID: <CAK7LNAT83SijpivFJA8GS=bOsgfnV03fo+-QJFgO1SgmLBOiQw@mail.gmail.com>
Message-ID: <CAK7LNAT83SijpivFJA8GS=bOsgfnV03fo+-QJFgO1SgmLBOiQw@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] Provide in-kernel headers to make extending kernel easier
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        atish patra <atishp04@gmail.com>,
        Daniel Colascione <dancol@google.com>,
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

On Sat, Apr 13, 2019 at 3:02 AM Joel Fernandes <joel@joelfernandes.org> wrote:

>
> > > +extern char kernel_headers_data;
> > > +extern char kernel_headers_data_end;
> > > +
> > > +static ssize_t
> > > +ikheaders_read_current(struct file *file, char __user *buf,
> >
> > Could you stretch this line ?
> > It will still fit in 80-cols.
> >
> > (This is a coding style error in kernel/configs.c)
>
> It takes 87 cols if I expand, so I'll leave it as is.
>


Sorry if what I said was unclear.

Since I just did not a good reason to put
"static ssize_t" in the previous line,
I meant like follows:


[Before]
static ssize_t
ikheaders_read_current(struct file *file, char __user *buf,
                       size_t len, loff_t *offset)



[After]
static ssize_t ikheaders_read_current(struct file *file, char __user *buf,
                                      size_t len, loff_t *offset)


(takes 74-cols.)


(I am sending this from Gmail, so I am not sure
how it will look like from you...)


Anyway, it is super-bikeshedding stuff.
It is OK as-is.



--
Best Regards
Masahiro Yamada
