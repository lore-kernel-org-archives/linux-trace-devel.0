Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C360C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Apr 2022 13:48:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357548AbiDDNuw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 09:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376846AbiDDNun (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 09:50:43 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129AC3EAB5
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Apr 2022 06:48:28 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id s72so8395419pgc.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 Apr 2022 06:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=I+XcIPm3IMEKQPxfm3+zajbEN7lnwpVZkTQ0oju0E94=;
        b=Q1exNh121QBMRasr8X3Vx/cphavrC73knUAbxcQcPbwCr8QsiKqNPebGkLHm9tVsEb
         YUa5h+cCzylK+EFllW+K99h4vTXw4lwnXmxoBl/J5tU72172Ik4yWVgijMK3ra2Y9o6p
         8Fm4zsdEOXz1unnwl1SW+MIbPgKelS248eguurScA7Le7ykaBGR0/G9NsKQjM1T8Xxpl
         q5U4NiOrMhbxOUbPGX3O/M/gzPZLt4xcnzaH6hI/ifl1F7hPRkxxHZjKCtaGrmPt50W/
         Q2iXj74GfgNFhXiaCUCVmsG/pgGOBIDKN1CqaT4RYA1XQraKuZxxSPbFysZfgK3xlM5D
         rOIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=I+XcIPm3IMEKQPxfm3+zajbEN7lnwpVZkTQ0oju0E94=;
        b=iUE4js1bHqWXLGhTKxjmanzlmosXFAJqDDp7U9lhN6CBM86/R2S1vyFN8mMqdVMKqR
         iBvt97DIUfAldoycS6I0z7lYsJ5nJaHSXSM/nIstRZzd0uMlV6EKVqE64/UwXhqL9v52
         /6h49oZ6SACPWHQUMPvJ/j6a4gaKnyEJDDxre9ok0wjUuE7Jx8l0zLveYSHNuyUESFKO
         PjlC3hv9u1uKWCJ2BJXgR9zdwL4Y6N9cfkLEFR4RIf5T9O1aladYTNVsjCYReTX6mz4Z
         26VEUJsn4YRStIZlFUGoqNe1Oj3RieGPbkjG3BcbbOo67wfJovIrVMu0Es9kdb24YS8R
         iAyg==
X-Gm-Message-State: AOAM531Jv0JfkYiedOS/5ki87C94GOj80a+0e9bt7DVQNRMJQtZu7buX
        QchExNZ0m/bE2QSQS42o0mUH3R6hDZmQo9ZPphUnf4NmIH8=
X-Google-Smtp-Source: ABdhPJzHlzmfkGDkg2zCj9ANmJX8Tha93SS+Y/u7cIdXdWgib3/KTni41aESR7S/GS+fAaSD4T4FaEubt+pwIRT3T10=
X-Received: by 2002:aa7:8617:0:b0:4fb:4fc:1ea8 with SMTP id
 p23-20020aa78617000000b004fb04fc1ea8mr52885623pfn.84.1649080107487; Mon, 04
 Apr 2022 06:48:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220329191801.429691-1-joel@joelfernandes.org>
 <20220401153737.7c444426@gandalf.local.home> <CAEXW_YQxPgaKOMhDy8kVdaT9esvY8ctP1Mfw3RZXwkJkTYhh0w@mail.gmail.com>
 <20220401190629.32564bd2@gandalf.local.home> <Ykm1jBpdD0+NjsTW@google.com>
 <CAPpZLN44k=2j7AsrNz72_74JkXQZvJH2sh61o2-ZRib=b4nyKA@mail.gmail.com>
 <CAPpZLN7LXehf7==O6bi2CDfs0HvAexAvQ1qv92MT5DYVgW7iGQ@mail.gmail.com> <CAEXW_YSUTdtELA+ZVmUsybuSMuZ0OAQy4d6834soj3a-R40v1Q@mail.gmail.com>
In-Reply-To: <CAEXW_YSUTdtELA+ZVmUsybuSMuZ0OAQy4d6834soj3a-R40v1Q@mail.gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 4 Apr 2022 16:48:11 +0300
Message-ID: <CAPpZLN5MHicswQqgH6vKYOCwPczNTyz2OcMf5CG4CKV6y8Q2jw@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd: Try alternate path for message cache
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        rostedt@google.com, Vineeth Pillai <vineethrp@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Apr 4, 2022 at 4:21 PM Joel Fernandes <joel@joelfernandes.org> wrot=
e:
>
> On Mon, Apr 4, 2022 at 1:03 AM Tzvetomir Stoyanov <tz.stoyanov@gmail.com>=
 wrote:
> >
> > On Mon, Apr 4, 2022 at 7:41 AM Tzvetomir Stoyanov <tz.stoyanov@gmail.co=
m> wrote:
> > >
> > > On Sun, Apr 3, 2022 at 5:56 PM Joel Fernandes <joel@joelfernandes.org=
> wrote:
> > > >
> > > > On Fri, Apr 01, 2022 at 07:06:29PM -0400, Steven Rostedt wrote:
> > > > > On Fri, 1 Apr 2022 15:50:10 -0400
> > > > > Joel Fernandes <joel@joelfernandes.org> wrote:
> > > > >
> > > > > > export TRACECMD_TEMPDIR=3D"/data"
> > > > > >
> > > > > > That=E2=80=99s fair. What about using memfd for this, do you fe=
el that=E2=80=99s
> > > > > > reasonable? I have not yet measured how big this file gets but =
if it=E2=80=99s
> > > > > > small enough that might work too.
> > > > >
> > > > > Is this a separate question? That is, do you mean using the above
> > > > > environment variable *and* then use memfd?
> > > > >
> > > > > I believe that the cache is used for passing the compressed data =
from the
> > > > > guest to the host. I don't think it will be more than one compres=
sed chunk.
> > > > >
> > > > > But Tzvetomir would know better.
> > > >
> > > > Hey Steve,
> > > > No its the same question. Instead of temp file, I was proposing in-=
memory
> > > > file using memfd_create(2), that way no hassle as long as the file =
is not too
> > > > huge.
> > > >
> > >
> > > Hi  Joel,
> > > That cache file is used for constructing the trace meta-data on the
> > > guest, before sending it to the host. Usually it is compressed, but i=
t
> > > could be uncompressed in some cases (depending on the configuration) =
-
> > > and in that case it can grow up to a few megabytes. Using memfd is ok
> > > in most cases, but I'm wondering in the worst case - these few
> > > megabytes could be a problem, especially if the guest runs with a
> > > minimum amount of memory.
> > >
> >
> > Can you check that file size on your Android setup with that command,
> > it will force to not use compression on the guest trace file:
> >    trace-cmd <host trace options> -A <guest> <guest trace options>
> > --file-version 7 --compression none
>
> The file grows to 5.3MB with this. Is this really the common case
> though? If not, I would still prefer memfd tbh. Is that Ok with you?
>

There are two cases that could hit this:
 1. Using a " --compression none" flag on the guest file. We could
disable that flag and force trace file v7 always to use compression. I
cannot imagine a use case for uncompressed trace file, maybe only for
debug purposes ?
 2. If, for some reason, there are no supported compression libraries
on the guest. Trace-cmd supports libz and libzstd, I believe both are
widely available. Theoretically it could be possible to have some
minimalistic VM image without any of these libraries.
What are the advantages of using memfd instead of temp file, is it
only for performance ? Usually collecting trace metadata is not
performance critical, as it is done before starting the trace.
I think that the best solution is to use memfd in case the guest file
is compressed and switch back to a temp file in case of a
not-compressed file.


> Thanks,
>
> - Joel



--=20
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
