Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A787CF05
	for <linux-trace-devel@vger.kernel.org>; Thu, 29 Feb 2024 19:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709236552; cv=none; b=FZiedRMZnMp2FXSmnZeR8cPcROAvw6pgTqeSNOY7jcHMshFfn4AgOLA3tdTctXZf2Sa3zO8PxIdJBZrPXQkfbSKrFL8wp6KMVFztpkL+VkAF/RxXXwrGTZ8vJWdKpAHIqPIKK4vK18YEz3ra7BbutmVea/i0OCnd2PYmKtSr0Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709236552; c=relaxed/simple;
	bh=EbuN3M/l3huoxCs7GfV+v2XE2e4wNGKkVeEHZJsG1Ro=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NfzaFe38YnZjRnzg98xZx5Pa+/dNbSS1PDP3CzjCvzO7mitOulMhhwiPFcSBfYKhMOQqPR+kZW37HGXIBbxlR2uNn0boK3W7XepJ8+rTqwPOJiRvn0OyZZu4WkQdv8DZDO6VhQtmw3+DM1BvcjqHHtMiEojBhwNVo5S99EKh4g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fwj8Xsa2; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fwj8Xsa2"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a2f22bfb4e6so242010766b.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Feb 2024 11:55:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709236549; x=1709841349; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kkTVGt2kRS6PYTAEHrah+kcNPpYexngVA/0ngpHykSo=;
        b=Fwj8Xsa2T3PXcU/99ZRRW3I/mmEDjY6OhVZwVbZJl6qXC+8l0SKdSPfe30ffBPJuGB
         ev+m4LWlbbJi5Uz4kTdLSb/gX/MnpIZGwYiSJ9TIFspZASYam126ZtOKuPWp6bQ63att
         HZVvNhHDY4J3brIrphYUCeSPalnl+ZjosEAv8gtWu/yRiFxpkbxaKmSPXb1n8AhnQKTT
         KBQCau2LKnf2DIT2M/+xRpcexy+GLVAWRLy/OmMl2hb1SHtx9KKFw9AWv+9thQuYljJT
         H3XuMmPUH6mWRByth3DBkb71mWcdTg0PnFVO0OWwPAD5CBtW4QMx0IsVgNJOvpPtCgo9
         rzgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709236549; x=1709841349;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kkTVGt2kRS6PYTAEHrah+kcNPpYexngVA/0ngpHykSo=;
        b=RrOlfNZMxWEIiPFFX4YGIl2H78y93YU7dReUDQl34nBbJ5ZsrbQL782QuDkWZ02dZa
         OlEYF37ZktInWA+x5X21bDHB6MQzOEsNA2KBsqfJHF+3NU/imXSjHsFrsS+7US5Fnuus
         g9bHlsLCSJznwZzMePnHPHgj5J7M/Ai1KomKPlBwmkPkFY4v4isMEe5In3+zMB8aU9WR
         nhFpI128y/93wu5C7T8gPVsR7P9+tOsgYA98j0+RRgHY7hDPzNc7yU9oq6bxUBX7nHvH
         /v3T0brblWdnNlRNvyxsTjXrpPrnSYqzTuiERbLHyo8RgXaUD9eUz+cUCCGVhOO50/VJ
         ZuKw==
X-Forwarded-Encrypted: i=1; AJvYcCW2+v4UuUYqGLqTUZdrNvpRaJ4C4NoG4rpVmQ5DUHO7Qmb5qAAdxiolrs9A2tgX2jNM87FkH8VpLc+gycB4+fgJRm5RU1rXigSJZyTmufsZLWM=
X-Gm-Message-State: AOJu0Ywq4yS2rDXZ6LXF+cvcc4PEIovlwfHr6Zv4PdjfFOAObAZwfhAO
	4dMgqorvBE6Uj7lS9h/VqqzQjB25DqYNj4y350rztPH42jorZDRsrzHKqiu7yRWKYLdM9qSDooQ
	/1Vdzm55UjfwT6OTnmX+ZXx1rXfM=
X-Google-Smtp-Source: AGHT+IHn3zClIcpEsDVLPoP/xIMHXDenR9wFTFL12jkR1zoMEz70Pc32sSil6RCS9z6KHjgRWVWdSavSCuHlivriKqc=
X-Received: by 2002:a17:906:4946:b0:a3f:1055:28b7 with SMTP id
 f6-20020a170906494600b00a3f105528b7mr2293945ejt.63.1709236549224; Thu, 29 Feb
 2024 11:55:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADVatmNXhhn6xhL-=rYqDaHqp4Ct+_i5N42KpeJnnxwoH1Ee+A@mail.gmail.com>
 <04601fe7-f487-c50c-1b8f-38662e92813f@gmail.com>
In-Reply-To: <04601fe7-f487-c50c-1b8f-38662e92813f@gmail.com>
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date: Thu, 29 Feb 2024 19:55:11 +0000
Message-ID: <CADVatmPECgAXGF164YmbqExBA1PCKYJ8ia-UhxWYs+yUpKo7Mg@mail.gmail.com>
Subject: Re: kernel-shark fails to display
To: Yordan Karadzhov <y.karadz@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, 
	Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Yordan,

On Wed, 28 Feb 2024 at 20:40, Yordan Karadzhov <y.karadz@gmail.com> wrote:
>
> Hi Sudip,
>
> First of all, I am sorry for the very log time it took me to react to
> the problem you found.

No problem. I was also busy and did not get the time to debug the issue further.

>
> I tried reproducing it on few different machines, but I am not able to
> see it. It would be great if you can help me a bit more, so that I can
> figure out what went wrong in your case.

I am wondering if I have messed up something while updating the package.

>
> It seems that the recording itself was successful, but later KernelShark
> fails to open the recorded file. Note that the file (trace.dat) must
> remain in the directory where you started KernelShark even after the
> abortion. Please try to open again this file in KS and check if this
> gives you the same error. If this is the case, send me the trace.dat
> file, so that I can investigate further.

The trace.dat is working, I have been able to open the same trace.dat
file with the previous version of kernelshark.
Next, I tried to open an old trace.dat (created with old kernelshark)
with the latest version  and that also failed.
I can send you the trace.dat and also a .deb package for Debian which
you can install and test, but it will take a few days. I can only do
it after the t64 transition is over.


-- 
Regards
Sudip
