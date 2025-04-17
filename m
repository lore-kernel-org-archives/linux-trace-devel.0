Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEAD6320F
	for <linux-trace-devel@vger.kernel.org>; Thu, 17 Apr 2025 09:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744880811; cv=none; b=rb6j8aE8Rbsyq5HXUZS+C7VGAl75G6PShYzJ9c6D5m56rSHgTIoCj1UUk88pjx+d0WytlqNkdkcvAyUcKJQBsKmbntoRKaQ5xkZXXY4dlMV78ML+S/zEbOKC8hw0kOTAVmt9nJ2Ry2noRRRRi4sjIJ4ESaJ1gxTrSYT+VI+7nnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744880811; c=relaxed/simple;
	bh=HtoSh656WrpvWVwLpX0WzwMiC873SRkVWd5KdDgMElo=;
	h=From:References:MIME-Version:In-Reply-To:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aztb2N+t1rwG3jrcGeXXDvHUWPdULzGTPNuw4RhnUo9Diy//VsDqdpYwJ+B9VaLLUxFyRQPEmWiMWGp/gvhrFf40zGHrQnTiAzfrdGkyac1grDzL7tcmdqM+BuKQ8GcKBOJiuyZAI82wfMwcOYcBj3qIj730ClHG4NtTi3nddC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=malat.biz; spf=none smtp.mailfrom=malat.biz; dkim=pass (2048-bit key) header.d=malat-biz.20230601.gappssmtp.com header.i=@malat-biz.20230601.gappssmtp.com header.b=HVI/CV7D; arc=none smtp.client-ip=209.85.222.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=malat.biz
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=malat.biz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=malat-biz.20230601.gappssmtp.com header.i=@malat-biz.20230601.gappssmtp.com header.b="HVI/CV7D"
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-86d5e42c924so494131241.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Apr 2025 02:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=malat-biz.20230601.gappssmtp.com; s=20230601; t=1744880806; x=1745485606; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:in-reply-to:mime-version:references
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=BPXQoN64nzMXQ0hxoLIiSKExc+wdm44qnrAuUIBCOjA=;
        b=HVI/CV7DoSsucwDRu/nnHCjW/utQ/xd3PJTlBCVAwrQQS0L5pu8bamnB2zUrNNLD4c
         JMlahJkaRHHISET1gFMRAtAqcDtY1zks3kHCBQWaIZAbBIBykgAhK76zaCJetHcym3W1
         WPgPsrSkYAN8MYWaLzm/9xwIPbpAM/NJZHdUXTgLJExZHxgmkKUbBZC3KhYJa4zM73IJ
         hPgaYr6Ra6cCaZ58gsD4FWbG1GO3MgNqT7w2t8QkCBagZMgwcAqdKl/9mOY6tpOuP4K0
         S+KJxb+mdQu2XUYhafmLoRJP7Hfl0ypvMv9fd/ZjTCnMqmKYJq85JGLmfT/ABxhoPdy+
         IF2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744880806; x=1745485606;
        h=cc:to:subject:message-id:date:in-reply-to:mime-version:references
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BPXQoN64nzMXQ0hxoLIiSKExc+wdm44qnrAuUIBCOjA=;
        b=s0siua7XOd30t3siIyv5ywUk2z9QrGXW62wZ1oLcHFz2+uhC/LJMJGhaPGSGkBLeTD
         FLGOrgm+pkFIfHg1uF/jk5NQIWG0xjhsKAxv/HxrIKm7+A3EotZmkAEQxQI3gY/9swTe
         1qEp+P+gLOf6Tr9mMme2XOoPjSz5YoMFR6FEONNOJREzxYCUQp0Xalv+byuRFkCWBREE
         Tw67IjpwbRldYogO9xHKtos+tOYkr6E7r0Ekl3tS/GX7M1av4ZNDKbCNnIGk9N3EyxQY
         dI3/eXVuL1cKMYFO80ZSQuiTOEjLN421V4+hb5m0Fxml3R/HM+r7RQs9QXtg7q+jN1lG
         q7eQ==
X-Gm-Message-State: AOJu0YxaLNVSGxwGJMFyhW7wt8bFdDJWT8OBAFkSPBJJ93iJgZ17Gk5M
	MyiFW9Lu6jkhoXllqDMfGMHbSoiPRP5NBNAHmxuULlkgt4Daez5hTV6qJEp27sQ5fNYjXHnO6Vl
	kYYt2SbVZzu29YXsZa0Bt2iLIcThJ9uWo6OjTYF094bU6FSEvZQ==
X-Gm-Gg: ASbGncuFUuTsoh9iPivO3eZwQdnk9kK9mIsf1VysANjyjzcOZXZvp7WkLWrzQyOfzcK
	RFeDJkT8PRzktg1ggkf08m7whXWdSrpKTeNR9Zd5h4m5pDDcTPSnU3r4nXx8mGrmDufiC2ajFd8
	G/vDrgBSviJKiTo14SeakH0g==
X-Google-Smtp-Source: AGHT+IGPDVyzddamsa/sZDczXBZau2oB3vg6L67k9LlP1JHE+UCZ1F/QlZKxUKkAkvA3HhbdR2EyXieKoSrDjfAuqZ0=
X-Received: by 2002:a05:6102:3b04:b0:4c3:6979:2ef with SMTP id
 ada2fe7eead31-4cb59311143mr3059151137.21.1744880806291; Thu, 17 Apr 2025
 02:06:46 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 17 Apr 2025 05:06:44 -0400
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 17 Apr 2025 05:06:44 -0400
From: Petr Malat <oss@malat.biz>
References: <20250409110705.437321-1-oss@malat.biz> <20250409225608.12df6ed8@gandalf.local.home>
 <20250414114117.6346acc3@gandalf.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250414114117.6346acc3@gandalf.local.home>
Date: Thu, 17 Apr 2025 05:06:44 -0400
X-Gm-Features: ATxdqUEfLme_EmQ1HyWLScITcaLzM7-Ob-dpgax8Tfmcays77nhhuhCgvxXas0c
Message-ID: <CANMuvJmtk8bbQnT1FgnLzidQ_L1uGrdYypTRoyvLkJhUFVUi=g@mail.gmail.com>
Subject: Re: [PATCH] libtraceevent plugins: Add plugin_net to handle bswap
 during print
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,
On Mon, Apr 14, 2025 at 11:41:17AM -0400, Steven Rostedt wrote:
> On Wed, 9 Apr 2025 22:56:08 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
> > As the else block will have args[0] already swapped wrt to host that's
> > reading the information. libtraceevent does a byte swap on values read when
> > the host and file do not match endianess.
>
> Does this patch work for you?
>
> I only compiled it, I haven't tested it against real functions.

Sorry for the late reply, I tested my patch on mips, arm, arm64 and x86 and
it works everywhere, but for arm64 I had to add extra functions, because
it doesn't use the GCC __builin for swapping bytes. I have extended the
plugin and will send a new version.

On mips using network order ntohs (and similar) expands to a cast only, so
the call to swap is not present.
BR,
  Petr
