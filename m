Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE7F194C96
	for <linux-trace-devel@vger.kernel.org>; Wed, 10 Jun 2026 04:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781065551; cv=pass; b=IxEk8OmHgSsDGz+nQ+7FKYLPSnKHktmuO3VQvc1wsCD3iz02JwD8F6xLreNPWa/CeJFp4MzEYC4oUza9/PHaQd9T5f+uP5P1ib6pDKgjgGNOE86HfjyFwXSJox5s1YkySgQgZD7pBmPiUvjvUSZCs1WZfd+E8n96fh93YGcVKc8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781065551; c=relaxed/simple;
	bh=fRG+fn0Odxl27LW0ptKRxlHOqtvgHqtF6HV0T8d2TLE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qqDpOPJY50ItBZakWurDnMquJkgRlhaL4RXjg9YsrJ5SJicCG1yihbwRVN7i/SiMGy8hGtqYU4i4jrrZ/nhmdcDS6STkTaSXbYAaWmtl+XO4J9Tq+Oswf41O2oaouqY8ualdtHlBFKlyfthFXYcLcZDpuOV4gHC8U/0bazeuH90=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DpnyXLKW; arc=pass smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DpnyXLKW"
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-69e4d51b15dso4201771eaf.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 09 Jun 2026 21:25:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781065549; cv=none;
        d=google.com; s=arc-20240605;
        b=MT9uQr8DX74zP/LBjihphTxOZA9rRGEfIMVrxZO1sSb9U0C4XpyT/2qYbyfXMexjbq
         HrSY/+AtYf8ORUNzWtS6ZzAlinuw0wawTwm0xf7AqryMSULVWfyGp6TA4s6zA7Bduk/C
         anEm7Mmfj7QyRa93x0wbmGrPnQVu6m4ydAhW0q4HtXZ2r1ftZJBvSkmfaoT3gMmAEhN4
         QVsnrepdmD0jJu2aPZBQL9NMW9MUBGolzYehwUpJNsZEY34n0zGFi8iSZFqsJgXzkwwa
         8WyCiBQkEToodh81UEX+dWYpskzh6/GJ4+cbuo2fsP/fnO9xmwriENEeiMapa2PDwVLw
         5HQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iTYUYCED7FD+BSNQFdeDODrFOFkZywHOI6NeyyhgDnY=;
        fh=S0EilolDaYOjZsgYYHnTJLDcGefATFj1cfCbbLaw4E4=;
        b=Y+1FT9I/6h1YLJ/tX2nTbGYKAnT2m9ZpmuYOQRGFRNmlEV4HXTMg/AZZQp5Ym5KKiq
         yzHnwQWpahzY5F3Rpe6meo5i8weQPR90Wg5B/DFM0fjttCqS5gjJ2jtb1EqQqd0sbYhs
         r6MooB2MfCsqGFMP7swS9iYTYfW0cQKRVyIoyxSzuWXDcf6fxfwEa5vvYAY1khD7L6W4
         L12HemDddz2qttn8UsU9TVpBILJXJzNxClvrZh4tE4FhoPlwcUBJEQzH9dO0qvH9MBcK
         u14B6E6RA/0PwYRVE+FaklxBig6ZKzTHkooqsmAHimMu/PZHI4gjxfFTHdBw5uqixbJF
         9phw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1781065549; x=1781670349; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iTYUYCED7FD+BSNQFdeDODrFOFkZywHOI6NeyyhgDnY=;
        b=DpnyXLKW2vOFu4HYsd6MKNOoaJ/VXBPIbPDCz+mUnD5PADDxZFtV+KhKUTQJL89w0B
         MZnaC3T+75NXCylecrFgcEZDaqHGl8H/WllrQGuPCUWxHT5+XBFu6YEDWDmDVy22hS7u
         wSv/5Pl3PI1hrFslhp3+YCaPWa6kl8E/Jbab0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781065549; x=1781670349;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iTYUYCED7FD+BSNQFdeDODrFOFkZywHOI6NeyyhgDnY=;
        b=Qc2JuVINwwygmS6Ig6r/qzvSFiLhSwJiVlr96thIF0SHJZkQD8fpzyqploZW/DhyOh
         3kC5csVc6ZObFrRQdTZuRPBzHFpkOtwn5zJYezsqeEmmZzXgwy1rJM23qIDi0SHPEplS
         KalK6jAM7gcjsetJ3XZuuXNtyyvE1vjHfabmLDZgx/Mzei8fC9LNMdVGVmshzu1pGfo9
         S8JOMc+cGlsCRYe4prk0CwFhp6oxVvgJIVtyPj1tXSssEfuJsZmQT+Y03X0MwLnRVTB3
         ij0BTni7HwKsebbyNFccpduTv2sXb6KIpkfyZ1w6kZhpfUNXOD/Zi1P+wCgqfyYxEexk
         VENg==
X-Forwarded-Encrypted: i=1; AFNElJ9lFpBNDoerQKozTdHX0PmPxVXoew3RKf4Sy2w664PVDWh6i7JwpBK5C0faFSi/eHXfcxN9v80ebq5XuDnGhoWAgg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxmCBraERECGX52D19tpHdWb1fl83hIr0IsNy0yo8hKkthBc/Ls
	8/jS5LGGh4+BHTk9IuZbItUOt4Kn836rqeUF0RJdW0HAxglI7WqRoqjfal8PlDyXMepoPKZlpA6
	6D8atqav7xluWu6d5+7u1PnfrVG/QAeA+KaGd0/ID5TNBxsReDOFy
X-Gm-Gg: Acq92OE9gguL9QFOHhky5JlhJ3qg7kndQZiPXJIc7YHQrIXjwRc0BDC6jZJ4oTbBX74
	xbR1KjWNcNl/sduuMACagUtg3RYWqtv1ZrdHV6I10qqiJMoT1BndwZs1XWKCpoNWkDdhDqxRVOD
	Nyw8FpIzC6ANrqPcsR2Xa2P+d56NDJ0Yx8dFfttNk6hbZdMfLI5sy5HgeVF45lobhB+WWQ6hZNP
	2uNAI2ENMrPp0ia/LvSGKImNNJ9v72k26E3WsSYY7DrwpkRZP/SGHOmffhgO73T43AGMNiPYKbM
	zEIuEEJ+LqIVpdy5EPdtiYgYXzwporRzyIUP7wkFDfdw0XVRa9sjaKfyC48=
X-Received: by 2002:a05:6820:81d3:b0:69e:55a3:35e0 with SMTP id
 006d021491bc7-69e68c55c5fmr14397196eaf.47.1781065549214; Tue, 09 Jun 2026
 21:25:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260529115528.1d0f92a5@fedora> <914607e6-1a51-e872-6383-292efecec61e@gmail.com>
 <20260609112223.3a17b5ba@fedora>
In-Reply-To: <20260609112223.3a17b5ba@fedora>
From: Christopher Hoy Poy <choypoy@linuxfoundation.org>
Date: Wed, 10 Jun 2026 12:25:37 +0800
X-Gm-Features: AVVi8CcAkz6x630PrxSCfhy7Jf5OePHV0J4FKeaa0trsLn_RFLFGlhNvYRHqegM
Message-ID: <CAKkv+gx_wkbBGVR7ucGTs++U52B0siVfvYN5phauuy=uJB92=w@mail.gmail.com>
Subject: Re: Documentation update to KernelShark
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Yordan Karadzhov <y.karadz@gmail.com>, 
	Linux Trace Devel <linux-trace-devel@vger.kernel.org>, helpdesk@kernel.org, 
	Konstantin Ryabitsev <mricon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Steven, Yordan

This is done.

Any queries, please reach out to helpdesk@kernel.org

Chris Hoy Poy
Senior Systems Engineer
Core Projects
The Linux Foundation
Perth, Western Australia (GMT:+8)

On Tue, Jun 9, 2026 at 11:42=E2=80=AFPM Steven Rostedt <rostedt@goodmis.org=
> wrote:
>
> On Thu, 4 Jun 2026 12:57:48 +0300
> Yordan Karadzhov <y.karadz@gmail.com> wrote:
>
> > Hi Steven,
> >
> > I am very happy to see a patch from you :-)
> >
> > The patch has been applied to the repo.
> >
> > I do have a PatchWork account. My username is ykaradzhov.
>
> Hi Konstantin,
>
> Is it possible to add Yordan's id to the list of possible "delegate to"
> entries? This is for "Linux-Trace Development":
>
>   https://patchwork.kernel.org/project/linux-trace-devel/list/
>
> Thanks,
>
> -- Steve
>
>
> >
> > Cheers,
> > Yordan
> >
> >
> > On 5/29/26 18:55, Steven Rostedt wrote:
> > > Hi Yordan,
> > >
> > > Can you apply this patch to the  repo:
> > >
> > >    https://patchwork.kernel.org/project/linux-trace-devel/patch/20251=
031115513.41b86970@gandalf.local.home/
> > >
> > > Also, you probably should have your name added to the PatchWork so th=
at
> > > I can delegate KernelShark patches to you, and that will make it easi=
er
> > > for what is needed for KernelShark.
> > >
> > > Do you have PatchWork account? If not, we should get you one (I Cc'd
> > > helpdesk@kernel.org to let them know you need one too).
> > >
> > > -- Steve
>
>
