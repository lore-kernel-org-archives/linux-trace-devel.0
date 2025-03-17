Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A071B07AE
	for <linux-trace-devel@vger.kernel.org>; Mon, 17 Mar 2025 17:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742231785; cv=none; b=HH6IqlIPSKlS58OqYcM+Wa2lChMDtRCmXjkAwGT0tOIyMkf3wsNKMiUevfbzLuQZ0FIIhZEzUpl9F/Zu9RVht9q30vuDnlwZOy4wuVE5aHSiMJwCvqX+BCZAus41s54UEx6+v75Z5k4KqvqlaYF0J/YHAOGTJ0WoiY8cR+Vl21U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742231785; c=relaxed/simple;
	bh=y6+fLLQ7kbH+0CzU5m2E0zr82FtMW+14mkUqDwtuBgU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SClKFLV8XctSSkCu4GApFatM7OrtJtks5T6HhoLWZE4hrqvhqRWZl7lnsCryz7iEtFW30j+U3Qo3OvG5ftmbFIBk5ySCmU1CNwebVgs4wR4T2/Iz828AfVheOrkWRVg0j0SZ0uf4mtDXv5FgK77Fz8vwAmVmmDggNj1IHGO7L5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ePmGmhB1; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ePmGmhB1"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2240aad70f2so67895ad.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Mar 2025 10:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742231783; x=1742836583; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DfFvXsXXQ4EwlZ+MVnsfd4i68TdMbHdFmvhxBUmT1PY=;
        b=ePmGmhB1uKNtuXQYhldQphoFZOkE7v9H9pgnT+SuGwLzzGvJmpDJ7NpdnEPMBeFD9f
         /eXbdWbyZExF0FhHz2NEBzuhr0vWEfb0n0qtKKF5BA9NZeuGHIT/9nSuDj6825oao94L
         C8+EqVtGvfovKmAIfwQp4FHWXeQ3vnZvrTcu/mH6C0HrlOJZ5iPNNXyxk/gg/FoaAVQT
         By9Rf7VNpwXbHt70fFNdM7mk7lFvnKV418JkisPm8ELeRBYUF+N+5VeAXkSQQO0dpCYe
         VJflBM+h+a5lLmEqVW6fBnkJ1bySyPW9cruMx06RLN89pmQq3Ur68ifMDyTxXuU5nAwj
         K7pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742231783; x=1742836583;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DfFvXsXXQ4EwlZ+MVnsfd4i68TdMbHdFmvhxBUmT1PY=;
        b=S4q5CbDy5pZo5Uavz1rHoxxyOnxftWefU4dKYjYz4QGPRpWKaowrlOKJk8bugCSjnF
         2Nr6hCkZufUC7ogWZkYTBf/ry+xexnxABsCguMx64Iyna3TRdCAkW66/mNFKvJXWpM52
         rXISn2DcaIsuUxhe5n6eKF0FEJSb8tqFpRb9S3f807zPeNRY8VK3fpux0p2oMDnnv2UF
         JHgdvu9pSiFyzrsLaKA648HVIRuvxbmBniXnjIwJVazJHATB2xOw4XlWEe17Z27g8rEY
         cXHbAyV0g/Ku0Ouw7ZPzq08itr7rjbeN/XBzhLzwBfA2FozUwIgR+AoLriJaQgDGQ08k
         l2ng==
X-Forwarded-Encrypted: i=1; AJvYcCXRKI7arg15Lg2DKqaxPDG+e6iPDwKxXQzVnxTxIyPTV/3zV2z93kM9q2QbJEkrjGnqff5IKJtsy3ESMpAgmRCPNg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3Ov7mMMnLDv6SW5HIkQqqQSEFz6fMcGMF7Ey/muhLLFyVea3m
	qf+on6c1U1ErskxqcT4xoU8GBE4BGI0VY/02dAUBhMwOIU7VPRdaKFbj9Mk6z9EQbvWu25lwWRf
	9wNDMz783+wD40nBk5GcFlJhWs5yIZLYxZivm
X-Gm-Gg: ASbGncsrrFqSRg2PjlLtAelEy4RaxHOZRbia9ru9Qkh2mGuzjAjaL/IW6lSeGjBXYMM
	DTnARNDQgzAbP6wkONU09obPZ95Gf104bVd9TdO41YfweHDkUKFeXgrW4V2SHNk6bqDAOPdkIWH
	zJVJ36ofIsf2cPc5zD51tVLeE/duJ5hNh4q4X5Bqp9CQJVV65G+HKFfEo=
X-Google-Smtp-Source: AGHT+IFhZ062stJ/0U82tGKw9QwiiDMz/O63ruW8fttZu4gPEgpShZspW4XGSrAF3kxnv/LvZFzzf24xhBBDXgeBowk=
X-Received: by 2002:a17:903:2441:b0:20c:f40e:6ec3 with SMTP id
 d9443c01a7336-225f3eb1adbmr4633195ad.22.1742231783195; Mon, 17 Mar 2025
 10:16:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <Z1mzpfAUi8zeiFOp@x1> <CAP-5=fWqpcwc021enM8uMChSgCRB+UW_6z7+=pdsQG9msLJsbw@mail.gmail.com>
 <Z9hWqwvNQO0GqH09@google.com>
In-Reply-To: <Z9hWqwvNQO0GqH09@google.com>
From: Ian Rogers <irogers@google.com>
Date: Mon, 17 Mar 2025 10:16:11 -0700
X-Gm-Features: AQ5f1Jp2d5UNDltp-P8jxNkRsUA61xne765QTZDlm7pFAHdCAdLEjY7qowx3yLY
Message-ID: <CAP-5=fWCWD5Rq5RR7NSMxrxmc1SUkK=8gg+D-JxGOgaHA7_WBA@mail.gmail.com>
Subject: Re: [PATCH 1/1 next] tools build: Remove the libunwind feature tests
 from the ones detected when test-all.o builds
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, Jiri Olsa <jolsa@kernel.org>, 
	Kan Liang <kan.liang@linux.intel.com>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-perf-users@vger.kernel.org, 
	bpf@vger.kernel.org, linux-trace-devel@vger.kernel.org, 
	Steven Rostedt <rostedt@goodmis.org>, Quentin Monnet <qmo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 17, 2025 at 10:06=E2=80=AFAM Namhyung Kim <namhyung@kernel.org>=
 wrote:
>
> Hello,
>
> On Mon, Mar 17, 2025 at 09:10:29AM -0700, Ian Rogers wrote:
> > On Wed, Dec 11, 2024 at 7:45=E2=80=AFAM Arnaldo Carvalho de Melo
> > <acme@kernel.org> wrote:
> > >
> > > We have a tools/build/feature/test-all.c that has the most common set=
 of
> > > features that perf uses and are expected to have its development file=
s
> > > available when building perf.
> > >
> > > When we made libwunwind opt-in we forgot to remove them from the list=
 of
> > > features that are assumed to be available when test-all.c builds, rem=
ove
> > > them.
> > >
> > > Before this patch:
> > >
> > >   $ rm -rf /tmp/b ; mkdir /tmp/b ; make -C tools/perf O=3D/tmp/b feat=
ure-dump ; grep feature-libunwind-aarch64=3D /tmp/b/FEATURE-DUMP
> > >   feature-libunwind-aarch64=3D1
> > >   $
> > >
> > > Even tho this not being test built and those header files being
> > > available:
> > >
> > >   $ head -5 tools/build/feature/test-libunwind-aarch64.c
> > >   // SPDX-License-Identifier: GPL-2.0
> > >   #include <libunwind-aarch64.h>
> > >   #include <stdlib.h>
> > >
> > >   extern int UNW_OBJ(dwarf_search_unwind_table) (unw_addr_space_t as,
> > >   $
> > >
> > > After this patch:
> > >
> > >   $ grep feature-libunwind- /tmp/b/FEATURE-DUMP
> > >   $
> > >
> > > Now an audit on what is being enabled when test-all.c builds will be
> > > performed.
> > >
> > > Fixes: 176c9d1e6a06f2fa ("tools features: Don't check for libunwind d=
evel files by default")
> > > Cc: Adrian Hunter <adrian.hunter@intel.com>
> > > Cc: Ian Rogers <irogers@google.com>
> > > Cc: James Clark <james.clark@linaro.org>
> > > Cc: Jiri Olsa <jolsa@kernel.org>
> > > Cc: Kan Liang <kan.liang@linux.intel.com>
> > > Cc: Namhyung Kim <namhyung@kernel.org>
> > > Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> >
> > Sorry for the delay on this.
> >
> > Reviewed-by: Ian Rogers <irogers@google.com>
>
> Thanks for the review, but I think this part is used by other tools like
> BPF and tracing.  It'd be nice to get reviews from them.

Sgtm. The patch hasn't had attention for 3 months. A quick grep for
"unwind" and "UNW_" shows only use in perf and the feature tests.

Thanks,
Ian
