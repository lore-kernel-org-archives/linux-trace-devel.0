Return-Path: <SRS0=6X2q=SS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 819BFC10F13
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Apr 2019 03:58:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45C362075B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Apr 2019 03:58:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="I0zPpGeL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbfDPD6Q (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 23:58:16 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:40059 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbfDPD6Q (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 23:58:16 -0400
Received: by mail-vs1-f67.google.com with SMTP id f22so10731587vso.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Apr 2019 20:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6O1vt8zyWL7/vWWLrY3NNehV0EhKXQOq2R1IZBHsBM0=;
        b=I0zPpGeLyvzz+csxGqpsE7zsCViKtWZhQaelft8C+qhDNxi30FqHEvOz2fVzv5d1+M
         ssIe7zjb3ELGM0QBfLlIM3E4lc4GF4kTNNAJybOtOZLnBWfr2Hkzy457MNmC5ybMQk2E
         Ko1+7yx9uOJu+W4AQSdHiN2Grir4tOwuZCWDA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6O1vt8zyWL7/vWWLrY3NNehV0EhKXQOq2R1IZBHsBM0=;
        b=H7uDlnV+KrhwAyTD467O5Yb/rGTqBwSPPu80R9fRGII8jaxI/Bs/K9/Y9qJnCmv+xO
         T1MrMm2QHhAYdEd5zMzRhDLQvu17mraSnX8KvrdphbVwEBQstPgMIGUYcSiqgRpfF1GT
         M7AvfV2gJLv7FqCLP+vSsiFreMktVdxMKyY6rsFZkYE0ZcdUmCH/Tp8WLLrmCdDkxjjh
         bZSzrX9NyEdMWMXKBH74a2P6KHQBpJ+UE/suxmcMcx+qNGfOrMkxz/8++UDRZXI2swIK
         Czea46a/6/DhUGnggvyZS7OvI8Dt4M1Vej9EzhT9JPeJfPVmDIu+C7TCDSjJ7D2f9qkf
         VQww==
X-Gm-Message-State: APjAAAXW4vme/ZhVEdf0QeQC726T3+X77fJDT8WQTE4DRW7Ee1JWPxCd
        UZcSwoWVcpMkdG05m4K/D1sFwLZ+J5Q=
X-Google-Smtp-Source: APXvYqybZ4H6F+ThWcj3U4BFdLSiyN6qRvpK6Ha5/X03Zw9p3F4Ra2s4sPVucS+eFbpTpeIu4e5d1g==
X-Received: by 2002:a67:ce03:: with SMTP id s3mr16398433vsl.97.1555387095482;
        Mon, 15 Apr 2019 20:58:15 -0700 (PDT)
Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com. [209.85.222.48])
        by smtp.gmail.com with ESMTPSA id s92sm10477659uas.2.2019.04.15.20.58.15
        for <linux-trace-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Apr 2019 20:58:15 -0700 (PDT)
Received: by mail-ua1-f48.google.com with SMTP id v7so6247081uak.13
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Apr 2019 20:58:15 -0700 (PDT)
X-Received: by 2002:ab0:154e:: with SMTP id p14mr3882445uae.48.1555386622555;
 Mon, 15 Apr 2019 20:50:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190320163116.39275-1-joel@joelfernandes.org>
 <CAOesGMheoZda84OSz9spQ7p66wot5S_9aaqaKC=QYp+8utASXA@mail.gmail.com>
 <20190408203601.GF133872@google.com> <CAOesGMibHCuMPCYkc8V++Z2Kuf3YQf_OjYn18GvDgzTy6ubV=g@mail.gmail.com>
 <CAJWu+or0hWce9+7aEfTHoOR8cptRbzHYVL-bPdJWGZH20dbo7Q@mail.gmail.com>
 <CAOesGMiuGK-Sbqo2z=1ab070JONav1LF82MRRLCdX-4+14_XZA@mail.gmail.com>
 <20190411031540.ehezr6kq7ouobpzx@ast-mbp.dhcp.thefacebook.com>
 <CAOesGMgiPB=7FE7tXXHes7WSLfByyPxirOStoH21NZqMwaUihQ@mail.gmail.com> <20190415104109.64d914f3@gandalf.local.home>
In-Reply-To: <20190415104109.64d914f3@gandalf.local.home>
From:   Kees Cook <keescook@chromium.org>
Date:   Mon, 15 Apr 2019 22:50:10 -0500
X-Gmail-Original-Message-ID: <CAGXu5j+KPVRcOJ3Ue9ZQF93GyaDhvCnFCvJ_C3WKCx2=SNdDyg@mail.gmail.com>
Message-ID: <CAGXu5j+KPVRcOJ3Ue9ZQF93GyaDhvCnFCvJ_C3WKCx2=SNdDyg@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] Provide in-kernel headers to make extending kernel easier
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Olof Johansson <olof@lixom.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Joel Fernandes <joelaf@google.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Qais Yousef <qais.yousef@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Manoj Rao <linux@manojrajarao.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        atish patra <atishp04@gmail.com>,
        Daniel Colascione <dancol@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Kees Cook <keescook@chromium.org>,
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

On Mon, Apr 15, 2019 at 9:41 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> I agree with this assessment. We shouldn't use config.gz as precedence
> for this solution. config.gz should have been in debugfs to begin with,
> but I don't believe debugfs was around when config.gz was introduced.
> (Don't have time to look into the history of the two).

I don't agree with this: /proc/config.gz is used by a lot of tools
that do sanity-check of running systems. This isn't _debugging_...
it's verifying correct kernel builds. It's a fancy version of checking
/proc/version.

-- 
Kees Cook
