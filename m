Return-Path: <SRS0=wXUw=2C=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D136C00454
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Dec 2019 15:18:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0912A2067C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Dec 2019 15:18:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aqscslob"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728929AbfLLPSW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Dec 2019 10:18:22 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:33081 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728939AbfLLPSW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Dec 2019 10:18:22 -0500
Received: by mail-io1-f65.google.com with SMTP id s25so3206875iob.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Dec 2019 07:18:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vlc7LfQTK4ryw6MypYbv7sjZW9QpLAQi0k68ADNHqFo=;
        b=aqscslobFafCa4oX/UsLZUpSQGKAdiNyy1D4oNEc+ZR0fDHZXHZD//fN99RijaEAh7
         pxNrsq9CFxctrfzzh9jIDvjj+1xR8+pvN0pDVR6xEibOAxaLIKpgKUZlTN6ijR10qjIF
         2pI2pGxN6kGiy/8QmKEwia+aiymkaLXBYUGVTcrgnnjKK6dr+bYUT4TMb97p2OTvXCQS
         /URDsJJlhvN2wBvq6NwOWr0C6I1TyYvNtNo3sv19TF0Oj927hXmb8FTZYVN3asix5y6o
         5xh/6MkD/4LQ8ecXN8MiVdqe6J+0XEV6nZXjT64Fb2AjKka2rvCYVK5hIUV9StN72p7I
         LRnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vlc7LfQTK4ryw6MypYbv7sjZW9QpLAQi0k68ADNHqFo=;
        b=p0yWeJ6d7lKYHZcosVypeEShGTekPLLuSHzH5D5yh/fRS0WEqy6BZPvmXv8A6GneNZ
         0mgar7Jfx/8jdwecsXCH/8FmjMVYT6ISlubRw58JNLsV4rlVcNVF4jM7ssqeBb0Nu6fV
         8GhPLVah1OIDipHv5+bUe2hCMRUtm9SmwXRnZ1lPe17/iJNpozVrJlVxJqdPy2AxB0sW
         gwlOMcyty6J3rKCamvWRvXEk+ESDbfBqvtl/zTSeburitsvRt4Mq/fV6d/8eb2MFeWa/
         AyfeNilQ9fDNax7SOaSJfonHCR+dkh9kroSC4ZRAelZdQn5Ys/0hFFKWLfLVZ1lJfrX5
         nIgA==
X-Gm-Message-State: APjAAAWdePfMBfxds0c7PxH8Yx4SxHHf0jPvSZZvefS6Xz8xoS99IEDi
        5PQOIwF8Tch02B7itsHc2DnUwWAJUPSNfnmChg==
X-Google-Smtp-Source: APXvYqz1ZTsHHJEt4sthuM2jAO+WxodaQhU0C3hTDsLSlZzH9AlU/09AkoOMBcGDEzKm3MZHaTR/ZJd44GTgRxVRS40=
X-Received: by 2002:a5d:8d95:: with SMTP id b21mr3382439ioj.303.1576163901825;
 Thu, 12 Dec 2019 07:18:21 -0800 (PST)
MIME-Version: 1.0
References: <20191128114500.6289-1-y.karadz@gmail.com> <CAE0o1Nvd1To0MtBAHdVQgb2g8h5Kh6s08hvxuXAz6fFVAXW-=w@mail.gmail.com>
 <bf0dba9c-57de-a9f6-151c-cd40bbd1c312@gmail.com>
In-Reply-To: <bf0dba9c-57de-a9f6-151c-cd40bbd1c312@gmail.com>
From:   Slavomir Kaslev <slavomir.kaslev@gmail.com>
Date:   Thu, 12 Dec 2019 17:18:10 +0200
Message-ID: <CAE0o1NsqJVjFgPyF09x-Hwog8cVGzr-m74PgM04CJg1i+oEjxw@mail.gmail.com>
Subject: Re: [PATCH] kernel-shark: Retrieve the home of root from "/etc/passwd"
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Dec 12, 2019 at 3:30 PM Yordan Karadzhov (VMware)
<y.karadz@gmail.com> wrote:
[...]

> Thanks for pointing out this!
> This simplifies the patch a lot. I am sending a new version.

I just saw the patch and I think I mislead you (sorry about that) by
referring you to getpwent(3), since getpwuid(3) is a better match for
this use-case and will make the patch even smaller.

-- 
Slavomir Kaslev
