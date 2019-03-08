Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CB93C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:42:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D1FB20661
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:42:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="ssezaFnN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfCHNmq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:42:46 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:37547 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726432AbfCHNmq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:42:46 -0500
Received: by mail-lf1-f67.google.com with SMTP id u2so7355663lfd.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:42:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Na2ICTCaMZ0QcHDv8RWM3swi5O8VFI4ZuZ2NbpUHrhU=;
        b=ssezaFnNfCTxDFxOwKtDQzdR9rpAu8PUWYVEF1UNq8770sFlQv53heVquoasbermH/
         HU4KvcFGnY3tiN4cZfB6C5umE35JPTFc0N20EebyAIxzeHzy4qmgAn0vUTKvAM4P75hD
         wvql1OikAYjzWupCLpGs8N4HH2rn+aPLpu70c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Na2ICTCaMZ0QcHDv8RWM3swi5O8VFI4ZuZ2NbpUHrhU=;
        b=bPHpLI7+xcbWYgftC7s9Q8qC7Yc4Pj/A7Js1qV/ivJViK6ukzN7/rDTJDPK51noGwj
         vz5hmPbdTV4Cwc3ntMaxM99eMi04Q3FFwaBppc4Att9P17loF6aoBPbhkxBcQzJOI2p0
         Ubfd9cGflez+DwhKA5EaA5VotD/DBsmOakhnfZK18Kd04UpyAdg0B0Aw3Q10kYAzshtg
         0gOVby8BcXRlOTpxfBxMqipOZ/yREgxpVgBGTaIMfsKLs2zrJGPUdXRGKB3ILiVGY2lg
         mv5HKdX7FaN64luKdssSds+pfFJ3cIEgqn3o8R7jH1xv0AWLoey0yCDg1ceadiEqh/4/
         ESXA==
X-Gm-Message-State: APjAAAVfuiwCjpZqmK68MX53/Wt0ac5Cc1LNPLD9Jpd7F5cZfDGLRryP
        2Rp6XHYcGOtTFtn3JKEWaQmbJydf65Bi+kaLNSJRtA==
X-Google-Smtp-Source: APXvYqyzWoypEqoT1oITYeUwNCwjb9vm61eT6BS7cBFz9jHtc8tf3vM63v6xdDxXMuteDgdGCzCS0SSwIXDskAdTkuc=
X-Received: by 2002:ac2:51b2:: with SMTP id f18mr10219675lfk.21.1552052563784;
 Fri, 08 Mar 2019 05:42:43 -0800 (PST)
MIME-Version: 1.0
References: <20190301160856.129678-1-joel@joelfernandes.org>
 <CAMuHMdU77UyUs-LvRx-NN_k0Y7MZXQkBdgL2i83veCkvdzeeqA@mail.gmail.com>
 <20190307150343.GB258852@google.com> <CAMuHMdW_7BTZREsnz7uMTToCZ4HDOZboMJH8k8UZica2pB=Jew@mail.gmail.com>
In-Reply-To: <CAMuHMdW_7BTZREsnz7uMTToCZ4HDOZboMJH8k8UZica2pB=Jew@mail.gmail.com>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Fri, 8 Mar 2019 05:42:32 -0800
Message-ID: <CAEXW_YQUcA+bnav20tAFQPXYE=epMie4X85diudKs_s-TJ7dsw@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] Provide in-kernel headers for making it easy to
 extend the kernel
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        atish patra <atishp04@gmail.com>,
        Daniel Colascione <dancol@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Kees Cook <keescook@chromium.org>,
        Android Kernel Team <kernel-team@android.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Manoj Rao <linux@manojrajarao.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
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

HI Geert,

On Fri, Mar 8, 2019, 3:53 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > It is just so much easier to use tar + xz at build time, and leave the
> > decompression task to the user. After decompression, the files will live on
> > the disk and the page-cache mechanism will free memory when/if the files fall
> > off the LRUs.
>
> I'm also considering how generic and extensible the solution is.
> What if people need other build artifacts in the future (e.g. signing key to
> load signed modules)?

That sounds like it could be useful. I don't see any reason off the
top why that would not be possible to add to the list of archived
files in the future. The patch allows populating the list of files
from Kbuild using ikh_file_list variable.

thanks,

 - Joel
