Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E008849659
	for <linux-trace-devel@vger.kernel.org>; Tue,  3 Jun 2025 08:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748940688; cv=none; b=LMKXbILky+cX5tN8s82K/iZc1Ow9l7+l0YSd6fb3xFT7YuerX+4euE0t6yGsw9NCedXB8oaHA1TvIAxzl/HOqVboPHfl4nv9zwt2VCXUl4EOXOqaAEJopgUHs/CxMFAa0BHSnwGItAHmU5gH5aO6hRCP3FnAUIqc4oWH6oUm+f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748940688; c=relaxed/simple;
	bh=kuoUjdRVz1JR+Dru/c3A0VJ4i3ZpzbpFaq4/HogX0Ig=;
	h=From:References:MIME-Version:In-Reply-To:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sWBV481kz1KP3ySq3dCB105xqCiEn6jDvY0ySPUd85/jSm3APmdQb/I/yH85bT42b1LmrUrnyrSrWAoaH4AuuPPd1ENrDzWaoVSIB6wpHnmOD33MwAdqDV+BYK7XeRllNx+lu2dRuTqUZmohI0cKnOMd1ynecoTFaXSelQ0Gt0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=malat.biz; spf=none smtp.mailfrom=malat.biz; dkim=pass (2048-bit key) header.d=malat-biz.20230601.gappssmtp.com header.i=@malat-biz.20230601.gappssmtp.com header.b=p7rs+CAG; arc=none smtp.client-ip=209.85.217.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=malat.biz
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=malat.biz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=malat-biz.20230601.gappssmtp.com header.i=@malat-biz.20230601.gappssmtp.com header.b="p7rs+CAG"
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-4e5a0ec639dso3531482137.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 03 Jun 2025 01:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=malat-biz.20230601.gappssmtp.com; s=20230601; t=1748940683; x=1749545483; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:in-reply-to:mime-version:references
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=FLHf20jBE5/CbDjCR0GqsLqbtZdlv92FFEJaNtFn6X8=;
        b=p7rs+CAGEmOCR01FG3GNG+5Bvm3VErZwXZxyl6y27tH1vqJljQpFMiGPT6UhFHWu6+
         3MphFBIogYz5aaCOnBP4XxypYQqz3iJUbdsfYmMPeqUC39liTgY2ZO7lruZwkO/jDaJ2
         DUTpmB3H2RBIJS+D+mcxRcxrLKfOptjdrnEgW+T+gqBHDsD5bETq6QRdyjJasGiVuB80
         09nfE8gG0OLt65mD/YMWKal+IY+O5etft878SyrZFgKUNy0fgJQ03O8exbMBiJhWMegL
         X5uUv6rDTFNcWOfX04coS2vbE0oUKrCacawctX3FdfsXmTHonadHmmb2zPRNcdjGoPyB
         VidQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748940683; x=1749545483;
        h=cc:to:subject:message-id:date:in-reply-to:mime-version:references
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FLHf20jBE5/CbDjCR0GqsLqbtZdlv92FFEJaNtFn6X8=;
        b=f8ODOC+Vp/xI9l2eur4l/qJn8rJmxqU0pxa8oNlG0QNa9wEEwuZwakk6REI1KWpni4
         58+prtmV+zJJ/aiXEXgKUzLuaVRsElWSFXWDRuE2Y83SWUGcBsoFcsGgEWvMvAjrCXUA
         wt+RFI/+TpIM3YuX1vz+Wdg8M1fVrmSJ4dQUkWsOaN76KU/8QL5v4IuDSXCL7Cvdvy/s
         Q1XYGVxdGye4fRR+Gt94VMP+NEEIkxeIlzgiyBIttLIe0luYZk9HvrAE00QqCntAHj/1
         pOh0Bzc6Ql1VavNDbeDJ78qKOJQo0hnjBSOZALmtTsFhQlMrGoJgtH8mEz1ewsOx2OEi
         UcUg==
X-Gm-Message-State: AOJu0Yz4sGtApD6CivX7Mi7h0uZWisjLshBM0xRH4AfPjYMPddHA/z8t
	aDNXwrpsTS255l8dfX9cMjfX3xN8aRSCj56BhVoQakDlAN3fX3nv/kzSQt2bO/dnl26XK1Mn9v7
	31Z5brp9ucl6AyRvShZT6OCNvSKwdqXOdk/QjjyyMV22BtlM9VH260Q==
X-Gm-Gg: ASbGncsbcsMQAdSxaHWuPUXWQ13rc3WF4hkfD2anQtur96DxI+hfp7EFCyT2xfKQjUa
	s2C6FK2u5sbMusMHqRg+0hbexbPiwwb/rakQgn7ldd65pnKW97eHN1Wk2p17I+jxbMbF9TCTESI
	2TRkFxExkqaQsuLkNKX5G57UTszqF2M0kBJD/Y5mOT2w==
X-Google-Smtp-Source: AGHT+IHf42nTLD7ItahX7Q6PTcHgnwclhtxmvIeJijH9fAYUzOqzp+AwQheCgCXv2gEOQe598+ARx6xxvEOYHKqXvBA=
X-Received: by 2002:a05:6102:3046:b0:4c5:4591:ffda with SMTP id
 ada2fe7eead31-4e6e41d4efcmr13999989137.21.1748940683564; Tue, 03 Jun 2025
 01:51:23 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 3 Jun 2025 04:51:23 -0400
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 3 Jun 2025 04:51:23 -0400
From: Petr Malat <oss@malat.biz>
References: <CANMuvJnWm0RpUCw+hMeqzGCig8hydUGYBZWKaNM44zGOM8jFqg@mail.gmail.com>
 <20250530101033.1dcf6f95@gandalf.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250530101033.1dcf6f95@gandalf.local.home>
Date: Tue, 3 Jun 2025 04:51:23 -0400
X-Gm-Features: AX0GCFtV0HOdq1QCOU_E1lo59gjcTse8z2uUXkOq0h0zqzjp6XhxFPCp1cdf4Lo
Message-ID: <CANMuvJk3JPs0BJBHk5CPJ_i2HXnT6VZkaEbfVpsv8rVdDSJTEw@mail.gmail.com>
Subject: Re: libtracecmd: tracecmd_filter_add filters unrelated events
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi!
On Fri, May 30, 2025 at 10:10:33AM -0400, Steven Rostedt wrote:
> On Tue, 27 May 2025 09:22:01 -0500
> Petr Malat <oss@malat.biz> wrote:
>
> > Hi,
> > when I attach a filter "subsys/event:field==val" using
> > tracecmd_filter_add(), it filters out all other events as well and
> > not just the event, for which the filter is relevant. I want to ask if
> > this is intentional or a bug. I expected the function to mirror filter
> > feature of ftrace, where setting a filter in events/subsys/event/filter
> > has no effect on other events than subsys/event.
> >
> > Per event filtering is done using tracecmd_follow_event(), so the
> > current behavior of tracecmd_filter_add() is redundant to it and
> > prevents creating per event filters without using custom callbacks.
> >
> > If this behavior is not intentional, I can prepare a patch to not filter
> > out events where none of the fillers is applicable to.
>
> Hmm, I think it was intentional because it's used to do filtering for
> trace-cmd report. Changing it will break behavior.
>
> It is supposed to follow what's in the man page: trace-cmd report
> under the -F option. If it doesn't follow that, then it is a bug.

Thanks for the clarification, I will use custom callbacks instead.
BR,
  Petr
