Return-Path: <SRS0=6X2q=SS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 739E0C10F13
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Apr 2019 17:22:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42370206B6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Apr 2019 17:22:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="NR1FsJ7c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728966AbfDPRWv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 16 Apr 2019 13:22:51 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:45431 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728466AbfDPRWv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Apr 2019 13:22:51 -0400
Received: by mail-lj1-f195.google.com with SMTP id y6so19814793ljd.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 16 Apr 2019 10:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=teLrKWBJL8PYLLheXxLHFCByZ+NGmGgF48F54jGmNmU=;
        b=NR1FsJ7cAE+Yhvw6jJ92R3jwPdAFWhBkmWNekvPM0VQugn4LtIkbgJdQ25zvJ31/s6
         EbAsB91gYIvJNKcsOJwyE3t4c9rtdAlNwp+anCsc0fYhptrZcarbrnfheOkROLuxzgmk
         zST7fuy0QSXlySwG2fvxvBU3UINxkvGuufenA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=teLrKWBJL8PYLLheXxLHFCByZ+NGmGgF48F54jGmNmU=;
        b=WkqgQ2aExdoffQtFIJhrBhb4oF9VgOoCgmu1dbwUsrug2D3eCCN6dwxEO/k6CVEBcT
         kmnmNGP6rkRY+KzonCWMZ9Mm8lbzrQeL4xbDxmpQyKH5xIyfP0ywBy5ks+O8JAS9oN5X
         KrqEnZnv671dn4GrA1ePDwxz5s1gbTxe7CfcJoFLhFUJiBQAZ76ihw1aAjuiPDo4+SrY
         OIQKzXujjdmrYDd0Rw46PsUcDMg/qMqzPyl+IxbSY9XoU7m/GYhhXIq29QVn7Yiy8sZL
         UnDfI6M0dcUlyxV0xkC1YvQ1OMlgF2CT3YzJRDLwxb0Wxf0p1H3PmufRi/nyHdE9vEIx
         v0+A==
X-Gm-Message-State: APjAAAWPMDYpMVByv+bOglOqZ0O7i8sZWA9hZ1MraS6DqO3sz3LJ7aNM
        bEPTbht1ErWM2rcKLrmfNC2e/+VgrzIc+gjaFrvjhw==
X-Google-Smtp-Source: APXvYqxZteqC8ERtgpAkWtZFuixQenPXlZ5ha+FDwpWOAVUTWKODqK1kWk7yAc4GvI7EbPzn7ayGGpGjIsXiUNdmUr4=
X-Received: by 2002:a2e:3803:: with SMTP id f3mr46633107lja.165.1555435369399;
 Tue, 16 Apr 2019 10:22:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190411031540.ehezr6kq7ouobpzx@ast-mbp.dhcp.thefacebook.com>
 <CAOesGMgiPB=7FE7tXXHes7WSLfByyPxirOStoH21NZqMwaUihQ@mail.gmail.com>
 <20190415104109.64d914f3@gandalf.local.home> <CAGXu5j+KPVRcOJ3Ue9ZQF93GyaDhvCnFCvJ_C3WKCx2=SNdDyg@mail.gmail.com>
 <20190416083306.5646a687@gandalf.local.home> <20190416124939.GB6027@kroah.com>
 <20190416130440.GA7944@localhost> <f8b15e31-1aab-ab2c-d44d-47325faab67d@opersys.com>
 <20190416094509.1af6326b@gandalf.local.home> <20190416142240.GA31920@kroah.com>
 <20190416164642.krptlz32zusr4pgn@ast-mbp.dhcp.thefacebook.com> <CAOesGMgGEZ8o-e2uAYLSGeO+RHcXAEzEoKcsjpveOLJZ5pX=4w@mail.gmail.com>
In-Reply-To: <CAOesGMgGEZ8o-e2uAYLSGeO+RHcXAEzEoKcsjpveOLJZ5pX=4w@mail.gmail.com>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Tue, 16 Apr 2019 13:22:38 -0400
Message-ID: <CAEXW_YS=C8FkC1h4ZQ6_jX8jY==Xe66c+q9cgM=Ci+N7SyNz6w@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] Provide in-kernel headers to make extending kernel easier
To:     Olof Johansson <olof@lixom.net>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Kees Cook <keescook@chromium.org>,
        Joel Fernandes <joelaf@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Qais Yousef <qais.yousef@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Manoj Rao <linux@manojrajarao.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        atish patra <atishp04@gmail.com>,
        Daniel Colascione <dancol@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Android Kernel Team <kernel-team@android.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Shuah Khan <shuah@kernel.org>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Apr 16, 2019 at 12:57 PM Olof Johansson <olof@lixom.net> wrote:
[snip]
> > Where kheaders.tar.xz is placed doesn't really matter.
> > /proc or /sys/kernel makes no real difference.
>
> If done in a location that isn't a perpetual ABI commitment, a tarball
> solution is something we can work with.

This is the part I don't get, Olof. It has to be an ABI commitment so
that the tools always work. Why are we so interested in breaking
userspace tools? We want a robust solution, not a fragile one.

thanks,

 - Joel
