Return-Path: <SRS0=1fLi=ZU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEE6AC432C0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Nov 2019 14:27:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F6D421774
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Nov 2019 14:27:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vLsQOROC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbfK1O1Y (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Nov 2019 09:27:24 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:34355 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbfK1O1Y (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Nov 2019 09:27:24 -0500
Received: by mail-io1-f65.google.com with SMTP id z193so29179319iof.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Nov 2019 06:27:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H6MXe9fJtyiaoZsGqfHc19BmpeynYN2MVsgOjbJE1eU=;
        b=vLsQOROCaf4Fr55AuOVUgPnuLagBFOSxa07YLyruAO7hI5UKqxnN24EP8cvV3OhZAB
         9R+S9Nc3fKpk4wY+bbS2e8H5hc2O+AgGjKI5Wp8mJh7qqPvaMR320cIAvcy3HNTF37No
         +5JpvHRC9uVrGcXN7xQaRiMU0iPw0+Om2ncwtQyqmwUaHFBnkU0x1zjpo+FRbFQl1q4I
         PDiGne/Ug0RgLHLEC6q4qkoCwzvuczvTuT142eB+0Jkc+TTGG9G+Gz72kWjIZb5lcJml
         J1DDIIgj0kxuD0OEJsxh29g9FvKC/1+KPPPLnNgEcKpQ9wHRIcUoJF7VHQkXxZrB6pKq
         lMWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H6MXe9fJtyiaoZsGqfHc19BmpeynYN2MVsgOjbJE1eU=;
        b=NAEg7KzQKW+cILx53hWFr2QuhxnXUCrDVbQc3WOkc3vpUG810jctGXDCfYzeJKxAuC
         QaUW/pptMZ3RMrJS6zussk/hG+jKXQwZlgyPTo3BqPf27b+6DE+14+qa2qFxn07AyL8q
         nuOxcjFb3nHv1Kb20dkOXwizDnoEm33ZkVZakep5JaRHmnJXKNxg3Shv+mM3yJD3G+Ee
         7KhkjSKcDY79gMagL6rZjrxndwSTI/pHGq88e2RInwFhyOzyvCxoTTFzpL0HiG2Y4zuJ
         Umaa4koRdg2uB6ZnvzG4q+VhbEhoLYdBlv9U0OqWeiItPoF4SPeVs7U6DnRD6kDtgD+X
         C4lQ==
X-Gm-Message-State: APjAAAUyzm7ItUek3QmpEVWftLnAnb744FfcaAh+Gj8nkYS42IVssoyU
        mWM6IodgW3YsIS0kbCsVtqs6eAuy9mCdH9o1bA==
X-Google-Smtp-Source: APXvYqyI6MlSY9lnAQeWRUxQwHf2s/OEW9+Nefoo1+OjY1R8+9BIFhifmK7NIWejil+p/glGRbRQCrG76CjnkdD9eZE=
X-Received: by 2002:a02:92c8:: with SMTP id c8mr9677579jah.2.1574951243241;
 Thu, 28 Nov 2019 06:27:23 -0800 (PST)
MIME-Version: 1.0
References: <20191128114500.6289-1-y.karadz@gmail.com>
In-Reply-To: <20191128114500.6289-1-y.karadz@gmail.com>
From:   Slavomir Kaslev <slavomir.kaslev@gmail.com>
Date:   Thu, 28 Nov 2019 16:27:11 +0200
Message-ID: <CAE0o1Nvd1To0MtBAHdVQgb2g8h5Kh6s08hvxuXAz6fFVAXW-=w@mail.gmail.com>
Subject: Re: [PATCH] kernel-shark: Retrieve the home of root from "/etc/passwd"
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Nov 28, 2019 at 1:46 PM Yordan Karadzhov (VMware)
<y.karadz@gmail.com> wrote:
[...]
> +       auto lamRootHome = [] () {
> +               QFile fPswd("/etc/passwd");
> +               QString home("/root");
> +               QStringList userInfo;
> +
> +               fPswd.open(QIODevice::ReadOnly);
> +               if (!fPswd.isOpen())
> +                       return home;
> +
> +               QTextStream s(&fPswd);
> +               while (!s.atEnd()) {
> +                       userInfo = s.readLine().split(':');
> +
> +                       /* Check the User Id. */
> +                       if (userInfo[2].toInt() == 0) {
> +                               home = userInfo[5];
> +                               break;
> +                       }
> +               }
> +

Another option is to use getpwent(3) [0] instead of parsing /etc/passwd by hand.

Cheers,

-- Slavi

[0] http://man7.org/linux/man-pages/man3/getpwent.3.html
