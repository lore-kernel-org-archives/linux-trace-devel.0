Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38CD16DED4
	for <linux-trace-devel@vger.kernel.org>; Tue, 28 May 2024 15:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716911517; cv=none; b=XgnEwUlHbyQpdV80IKvAH4/wL6pMEOiFAXUEHvPh13jdYWVigcPjCcvf2jTZwaJ98bzlMW6OmswwfaNJLXC95swhpa1v7kDw6Hf9J7stzv1w3KyeQgYSW5V3fbnmvYfo/XYXzgVyufg+fFnkpkrx+A57+CmBVznKvj8G4c0iJic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716911517; c=relaxed/simple;
	bh=egaaseC9Tk764UbW/+2JHwmr1VEVanmF3gGWl4wFBgc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k+pxNQwXkBB8ZLii195qRErA84PYr8D4wF3xcflDSjfEV+4ELOA2BZjtCvWQuXEP/eVo4cDJ+Cs4FFujzUVV71ddWy2xqyN1Gd5dSFRI3lwzUFC1RW+aRm8zkxd2Wqn4Reo9fQPA1LxPZicvUJgEc5KsQ4bPKxADxlEcGbMaw7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z/WCzZ2Y; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z/WCzZ2Y"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-43f87dd6866so939131cf.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 28 May 2024 08:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716911514; x=1717516314; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=egaaseC9Tk764UbW/+2JHwmr1VEVanmF3gGWl4wFBgc=;
        b=Z/WCzZ2YzcfCBFBtlgzfOUA1fh1HoTJFo9FuvGotKe7OGimbrUA+xyJ8ipWjBEjaek
         +KfSKF/tjeTWhX0V8+tndUppk2WkUA76fyps1IZ2LBmxNTGVcRPE7ybrQa/FuN3QJ2wP
         AtOvFO9vVtkC1egveTWHFNrB1W3QO2eNpfMW7ho9EZR4rHPZ6NcICKCckLdBHRSFufUG
         wVstDjnn09PGSvsmhy0Xd8COheaLO9SSycVXn5rH3xlwovD625A7pRPHvCQgkWMXL6xz
         GGtlsVUyT4pZcFBlth234BMw9F9gwQmjELP/QatRA5A/QNx2uZnaBiCsb/lOH3QN2wUG
         J3uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716911514; x=1717516314;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=egaaseC9Tk764UbW/+2JHwmr1VEVanmF3gGWl4wFBgc=;
        b=Smn9FEX4RQfAQ9x+UC78JsckvmHckyZnDoIBP/XqhdbIpoI9QtmDIoKW/1ZrP0IFJT
         km4xFnO/716RedA2xr9hdM6miU9fNsSYNV11uE77g5X5EJ7FC9h25HJnZ9ge5BkOdJYS
         B7M+p4xQ158XJonlTit6a3VDWex2ZJuor1ip9vsfHxHACeuWGQLAajq1PvJs0Jha3gh4
         oTkcL6bXgc75tfou6O1b+3kFmH2JmSzf63jMvO6Dwtgod7CSVOyfYUrAVF5o5tNKHMOf
         B7pahYTyfKbq1AkzMgfgX+nopPoSJ86HJNlF6IxPss0oqUiXjfAK4f5s04Kq1bzw5hBi
         05fg==
X-Gm-Message-State: AOJu0YxpjBqTnPShBHYnpJmFvLDb/VCGSnNC/lj2SSe8NnumESmi/H+5
	lmBh9h7CxIVN/3pmx+Y7dbVamFVpZ1k6fkQKYddWlVndnm3IjtDMm8NKM64zZdpwADBWt9OJyco
	DBGlS6bODD+gAOC5agQesT42qLc1G7BOobHL38Na2rVC9Vzi9rbNU
X-Google-Smtp-Source: AGHT+IFW701iW9ic3qWtuMhS2jQiWX3Jt/d+1REJJrlGxDzIxzIfCooGcHVRznCb2gfGs8TAq+Fh/iGy6NxUmi0/3jo=
X-Received: by 2002:a05:622a:6207:b0:43d:f9ec:2055 with SMTP id
 d75a77b69052e-43fb9fab992mr5784401cf.26.1716911514394; Tue, 28 May 2024
 08:51:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240509051317.1913001-1-irogers@google.com> <20240516180248.24aa5aeb@rorschach.local.home>
 <CAP-5=fUYxxmH8X0RVhdSWzKFT+WJO_UDULCtO4PK+VO-osXwGA@mail.gmail.com> <20240516195110.2b91d4d9@rorschach.local.home>
In-Reply-To: <20240516195110.2b91d4d9@rorschach.local.home>
From: Ian Rogers <irogers@google.com>
Date: Tue, 28 May 2024 08:51:43 -0700
Message-ID: <CAP-5=fXjJjLZ+wua-HuCKePs3WrOy+snzCjr-08cFgbb3OW-yg@mail.gmail.com>
Subject: Re: [PATCH v1] libtraceevent: Avoid a simple asprintf case
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 16, 2024 at 4:51=E2=80=AFPM Steven Rostedt <rostedt@goodmis.org=
> wrote:
>
> On Thu, 16 May 2024 15:09:40 -0700
> Ian Rogers <irogers@google.com> wrote:
>
> > > This states what the patch does, but omits why. What's wrong with
> > > asprintf() here?
> >
> > Nothing except overhead. I was tracking down an asprintf issue [1],
> > asprintf breaking the sanitizer stack traces on my debian based linux,
> > and using asprintf for the sake of copying a character was creating a
> > huge amount of noise for me. 2 lines-of-code extra means this change
> > is by one measure more complex but it removes special knowledge of
> > asprintf return values and the meaning of %c, so on the other hand it
> > is less complex. I won't be offended if it's not accepted.
>
> I don't mind taking the patch, but the above description is needed in
> the change log, as that explains the purpose of the patch.
>
> You don't need to resend, I'll just cut and paste what you wrote above
> to the commit message.

Thanks, the commit message LGTM.

Ian

> Thanks,
>
> -- Steve
