Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA024C433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Apr 2022 13:21:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347995AbiDDNXd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 09:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241154AbiDDNXd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 09:23:33 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A2E3DA68
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Apr 2022 06:21:37 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id v13so1856215ilg.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 Apr 2022 06:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uBUmXev4EAz77Tw6q/tuGAQVTU4QIBybOo7YkH83RPI=;
        b=riUoqlxisTnu2xCU3hEH42w+d1nwKl7oVYidORCxjKdJFd/KcIOsC7FzfV8Uohtto1
         lSvlE5ZXHDthvjtlMIy0o/0Q7MphB6bVI9m+wmBCrKc2gGqS4UdIpj7mdY48+fJRBIrL
         IeZS3XewC1WtCS1ve4jlRkgtjxRb1QBJW49MY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uBUmXev4EAz77Tw6q/tuGAQVTU4QIBybOo7YkH83RPI=;
        b=A5qiGt7jInlscSbGqBXqsV+yYfRcTVkHBfUML82jOWO0l26bso2aIPSaE1HOfhhUne
         x5Oqpu3BmjEoA6JUcJenvTfuCnL+RhaMo0FcYJKb9TxnmYmQfZTwp8T8jQTBoywkIWgt
         vMM1g4+8H6xhWvc9XBnan6t8/YDO86RF/yKHxGnxUTonuvzhW853OF+EfA1wZ077UK4b
         qUZ/uKtUet5xpt5cRWLyw4K/79v6uBeW04ULE3l1/BQ3oW42RECfKil9eAsQeaqxOo7p
         STkl7wmifVkkwgBY7s5n02BO0IfrI0NouA+wHARnzmxTn3h6Yiya3JkXMKySLGAzMxI7
         lWCA==
X-Gm-Message-State: AOAM530laGhTCnLgag+e4rYynE+ghInAZ5VCJjkFmOHADW2a8iZcg16h
        S4mSYwEVQqAkcCkg4tXXHTo6tDXgo1P5W0RkVxPFtA==
X-Google-Smtp-Source: ABdhPJwPq9Tpnjk4UddZwMH9A3t1R7NqqetgoZdI1M+PVqe+lvzf8WnrJjRCC0cMG4cmGy6vtuzPB4HKd+nKTVL4Ly8=
X-Received: by 2002:a05:6e02:1c88:b0:2c8:31b6:531f with SMTP id
 w8-20020a056e021c8800b002c831b6531fmr5656096ill.286.1649078496711; Mon, 04
 Apr 2022 06:21:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220329191801.429691-1-joel@joelfernandes.org>
 <20220401153737.7c444426@gandalf.local.home> <CAEXW_YQxPgaKOMhDy8kVdaT9esvY8ctP1Mfw3RZXwkJkTYhh0w@mail.gmail.com>
 <20220401190629.32564bd2@gandalf.local.home> <Ykm1jBpdD0+NjsTW@google.com>
 <CAPpZLN44k=2j7AsrNz72_74JkXQZvJH2sh61o2-ZRib=b4nyKA@mail.gmail.com> <CAPpZLN7LXehf7==O6bi2CDfs0HvAexAvQ1qv92MT5DYVgW7iGQ@mail.gmail.com>
In-Reply-To: <CAPpZLN7LXehf7==O6bi2CDfs0HvAexAvQ1qv92MT5DYVgW7iGQ@mail.gmail.com>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Mon, 4 Apr 2022 09:21:30 -0400
Message-ID: <CAEXW_YSUTdtELA+ZVmUsybuSMuZ0OAQy4d6834soj3a-R40v1Q@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd: Try alternate path for message cache
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        rostedt@google.com, Vineeth Pillai <vineethrp@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Apr 4, 2022 at 1:03 AM Tzvetomir Stoyanov <tz.stoyanov@gmail.com> w=
rote:
>
> On Mon, Apr 4, 2022 at 7:41 AM Tzvetomir Stoyanov <tz.stoyanov@gmail.com>=
 wrote:
> >
> > On Sun, Apr 3, 2022 at 5:56 PM Joel Fernandes <joel@joelfernandes.org> =
wrote:
> > >
> > > On Fri, Apr 01, 2022 at 07:06:29PM -0400, Steven Rostedt wrote:
> > > > On Fri, 1 Apr 2022 15:50:10 -0400
> > > > Joel Fernandes <joel@joelfernandes.org> wrote:
> > > >
> > > > > export TRACECMD_TEMPDIR=3D"/data"
> > > > >
> > > > > That=E2=80=99s fair. What about using memfd for this, do you feel=
 that=E2=80=99s
> > > > > reasonable? I have not yet measured how big this file gets but if=
 it=E2=80=99s
> > > > > small enough that might work too.
> > > >
> > > > Is this a separate question? That is, do you mean using the above
> > > > environment variable *and* then use memfd?
> > > >
> > > > I believe that the cache is used for passing the compressed data fr=
om the
> > > > guest to the host. I don't think it will be more than one compresse=
d chunk.
> > > >
> > > > But Tzvetomir would know better.
> > >
> > > Hey Steve,
> > > No its the same question. Instead of temp file, I was proposing in-me=
mory
> > > file using memfd_create(2), that way no hassle as long as the file is=
 not too
> > > huge.
> > >
> >
> > Hi  Joel,
> > That cache file is used for constructing the trace meta-data on the
> > guest, before sending it to the host. Usually it is compressed, but it
> > could be uncompressed in some cases (depending on the configuration) -
> > and in that case it can grow up to a few megabytes. Using memfd is ok
> > in most cases, but I'm wondering in the worst case - these few
> > megabytes could be a problem, especially if the guest runs with a
> > minimum amount of memory.
> >
>
> Can you check that file size on your Android setup with that command,
> it will force to not use compression on the guest trace file:
>    trace-cmd <host trace options> -A <guest> <guest trace options>
> --file-version 7 --compression none

The file grows to 5.3MB with this. Is this really the common case
though? If not, I would still prefer memfd tbh. Is that Ok with you?

Thanks,

- Joel
