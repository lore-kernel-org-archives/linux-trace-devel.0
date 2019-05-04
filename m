Return-Path: <SRS0=6G4v=TE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DA85C43219
	for <linux-trace-devel@archiver.kernel.org>; Sat,  4 May 2019 07:46:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 093FD206BB
	for <linux-trace-devel@archiver.kernel.org>; Sat,  4 May 2019 07:46:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CV3UT7a8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbfEDHqg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 4 May 2019 03:46:36 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:43734 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbfEDHqg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 4 May 2019 03:46:36 -0400
Received: by mail-lf1-f65.google.com with SMTP id u27so5643234lfg.10;
        Sat, 04 May 2019 00:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pLFz5m7MYmJEVrrsTqrGVDLstDPzFzUTpq+rCiXCbKg=;
        b=CV3UT7a8s0FX9ng4FgOGpd/mX425h53C5N9wYIMt0rX3rvLIJ3+CGLxWvO3ClZtzPx
         +QY6ivoifgR21reCSC4DRJxaqDFEis93MqW61yZdIj5Viz2k4f81FwYmGHU/lwSyx4lv
         6maDOed8b4I3Ju3Wuiqw69Q3txTR8EhIJI7k+XV5U1h+s32cD0I0dEt+gyNQaTYhPBJl
         CTgVDSVVYmKHa670PWIYKDXzaAXOh8GwwVjfVB/ruA+9UpRdIO6OsMcohFJlvOCKj55z
         RojVQPBF6FkjZkuttqJwJZJL0dF0RVlpj2G1sQwmhK7ITHUx1HuMYYojQALRzSs18KKK
         t1qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pLFz5m7MYmJEVrrsTqrGVDLstDPzFzUTpq+rCiXCbKg=;
        b=KV/Q7awVTNpFkMgWzP4GPlo8dZNzVC5haSsUYrsYZwqcKjvJJt/WNt4xj0kkAmr4qq
         gxLFf5tsWRlkLp3+zlKTJ7qvMvbtz8e6FXIW3jlHjpluZZVUTu6ey4PgJKzTPo3OWrdW
         XieJ+18FFf84aNnhK49QmDa7/pb0hjCK+eg+Dp1ecpDCypi7IRmSa+YXOdXoKT+TszUN
         FwSbiAsdi1wBKzp91FgTfE/He3gNwNUzBVRu3cITw7pu0SBhCO+rwh0v9OuXhHa7DVcd
         mKPBi16gBTRahPOj22joi+yp1eTRbyEAToiQhtpL1HF9N5fWARDrljeT6PuY5pxwUzE9
         FJNA==
X-Gm-Message-State: APjAAAUTtB7b983oUvYmxZMXFUyXqkEdJfj3HICubb9nazhh58BfRzqS
        DrlsqUHoiEGdZVhwxst+NZGpgMuvplOXgNFfLQE=
X-Google-Smtp-Source: APXvYqwaMp9tMmsjbEnJ+VVIQ4xWXBbxYzlgt7/vJuFoe9tJd1VoTFn+QpDd/6nH18mHpd9dcCLEL8HA6GAtzzwjPXY=
X-Received: by 2002:a19:81d4:: with SMTP id c203mr7287084lfd.160.1556955993483;
 Sat, 04 May 2019 00:46:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190503182459.159121-1-joel@joelfernandes.org>
 <CAK7LNATRTqh_OJcQaWfcYYYqyZ-c0u1prD17LDYwDh18z2V31Q@mail.gmail.com>
 <CAK7LNASkR7cauvcLprgrTKNv-iY4yjS278FPGJ-UEYTBrANKYw@mail.gmail.com> <20190504005920.GA261146@google.com>
In-Reply-To: <20190504005920.GA261146@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 4 May 2019 00:46:21 -0700
Message-ID: <CAADnVQKh6yVgYR_cZ56MSQ2WxfBjFYaQxbEH=xaeM0FjxAeaZg@mail.gmail.com>
Subject: Re: [PATCH] kheaders: Move from proc to sysfs
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Adrian Ratiu <adrian.ratiu@collabora.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        atish patra <atishp04@gmail.com>, bpf <bpf@vger.kernel.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Daniel Colascione <dancol@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dan Williams <dan.j.williams@intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        duyuchao <yuchao.du@unisoc.com>,
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
        Manjo Raja Rao <linux@manojrajarao.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        =?UTF-8?Q?Micha=C5=82_Gregorczyk?= <michalgr@fb.com>,
        Michal Gregorczyk <michalgr@live.com>,
        Mohammad Husain <russoue@gmail.com>,
        Olof Johansson <olof@lixom.net>,
        Qais Yousef <qais.yousef@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Shuah Khan <shuah@kernel.org>,
        Srinivas Ramana <sramana@codeaurora.org>,
        Tamir Carmeli <carmeli.tamir@gmail.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, May 3, 2019 at 5:59 PM Joel Fernandes <joel@joelfernandes.org> wrote:
>
> On Sat, May 04, 2019 at 09:21:41AM +0900, Masahiro Yamada wrote:
> > On Sat, May 4, 2019 at 9:18 AM Masahiro Yamada
> > <yamada.masahiro@socionext.com> wrote:
> > >
> > > On Sat, May 4, 2019 at 3:27 AM Joel Fernandes (Google)
> > > <joel@joelfernandes.org> wrote:
> > > >
> > > > The kheaders archive consisting of the kernel headers used for compiling
> > > > bpf programs is in /proc. However there is concern that moving it here
> > > > will make it permanent. Let us move it to /sys/kernel as discussed [1].
> > > >
> > > > [1] https://lore.kernel.org/patchwork/patch/1067310/#1265969
> > > >
> > > > Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> > > > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > > > ---
> > > > This patch applies on top of the previous patch that was applied to the
> > > > driver tree:
> > > > https://lore.kernel.org/patchwork/patch/1067310/

I think it would be cleaner to take it out, squash and reapply.
