Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E47A181D05;
	Wed, 17 Jul 2024 20:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721247447; cv=none; b=erTTKKHBzijHDd7uUD++11XHkOJ6+Zg91NUjarsBAmBLZgQAD7H6X9QeakqvvTW5oRs6o78kKU/LXiV2q5pWTbMYf+SJ0FYhhH52RXPTEfKmuF3vu+RAWIQWssxatXz6pszS+C5pqRkDX1iU9j1NPlPmG58NrPAbjLu1Mg0yE3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721247447; c=relaxed/simple;
	bh=JT3g53fcSmIbb0K1OvAoRy3KDMRTTQ9/L89HkJWtbY4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uf4uaVev7kIPlvmAE+N/v+2tT9cQ11MnaX5vig1GSnHF0tVXV6Sw5JbQ59kRHknfcrVFxmZlQHE3U0IITvWMg/bhhxo+XBhLm2/HbG+aOX7D7/jscqJvFqv3vk8Cgb9gY7Ui6ooMSLCuYipTQFuqPzxg+FrSBgWl/py5kqpIMQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1fc52394c92so1233765ad.1;
        Wed, 17 Jul 2024 13:17:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721247446; x=1721852246;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JT3g53fcSmIbb0K1OvAoRy3KDMRTTQ9/L89HkJWtbY4=;
        b=XUuSykTXh50H44jCd1yrcCcRrrUGDzFAaSnMI4WJPF6NtCA6dmS71Ddfmu+XU1bgn7
         J6tA+1T28clmJcLp8zAYaIF3UlEK7lr+8JJY111vjGeH1vgM+fnwQeT4lYCIwNbjpU6Q
         CJ21SC4KdjnEDfwGUyfhwcXX9KViwTtiQITdJS6Ag5rysDV9CkglmBnevcNCLe5qglyN
         DVtn7Plr0VYnPFU/6hZnaxQuqwhgOTdNl993UlNJhbvDa3KvHA03AFMXABlrEzDwE+Vi
         +RVYrHkZTFjI5powlTTYpVSJxcb2fLX6AbJIFEwW8ncIZoPZPWf0gUt9VhW7RljU37Qs
         MvQA==
X-Forwarded-Encrypted: i=1; AJvYcCVcPM7guQKL4aeeqfG10gIoGl+53OPPCTSPSH1dXCH0BBpxDjT/oUIxQKwiqVkmMGh02iT17iachsBRVvg7lAx9mW+qkc3fQCrKt4T/Wps8QEnnM5WFilrE9E6H/VhLoFHYGskLoZt0fNYGIrjm+4Kv42FF0i+IEOFNmfq5ngljXc3pSGCj8iVdWE7+DW5Jb1I7
X-Gm-Message-State: AOJu0Yw0a/5IuP1tuQkYR5QIPzPlemXlFSMYI4R1qyTYFEsdE1IZVTq+
	uWhTFn5McKm5OWSXH+DmPcLyIihm3Q8Rt5mVSisR2XxpC634aaeenfJ3DrieWf1xMmyNWWU12JW
	ysqsK3Bq6LMTBEwSYGVUI8N30ywU=
X-Google-Smtp-Source: AGHT+IF1DtZXkYokgsSPIEfnEBClwMlGpa3y53AVbDZplBgFirVuEW2ds4z6XwqPlGIt5ml/+agwaq/lVMxE3Y0ZCug=
X-Received: by 2002:a17:902:d54f:b0:1fc:54f6:9f72 with SMTP id
 d9443c01a7336-1fc54f6a40fmr18980475ad.64.1721247445422; Wed, 17 Jul 2024
 13:17:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240717123147.17169873@rorschach.local.home> <20240717174739.186988-1-amadio@gentoo.org>
 <20240717135759.37cf1bcf@rorschach.local.home>
In-Reply-To: <20240717135759.37cf1bcf@rorschach.local.home>
From: Namhyung Kim <namhyung@kernel.org>
Date: Wed, 17 Jul 2024 13:17:13 -0700
Message-ID: <CAM9d7ciaNB+dnhbqpSztd=O51mTXxvzr_bdA-NHzSCboUEyAMw@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] perf build: libtraceevent, libtracefs feature
 check with pkg-config
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Guilherme Amadio <amadio@gentoo.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Ian Rogers <irogers@google.com>, 
	Thorsten Leemhuis <linux@leemhuis.info>, Leo Yan <leo.yan@arm.com>, linux-perf-users@vger.kernel.org, 
	linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 17, 2024 at 10:58=E2=80=AFAM Steven Rostedt <rostedt@goodmis.or=
g> wrote:
>
> On Wed, 17 Jul 2024 19:47:34 +0200
> Guilherme Amadio <amadio@gentoo.org> wrote:
>
> > There is no change in this new submission relative to the last (which h=
as been
> > tested by Thorsten to fix the build issue in Fedora). The only change h=
as been
> > to add in CC Steven Rostedt and the list linux-trace-devel@vger.kernel.=
org.
>
> Thanks,
>
> For the whole series:
>
> Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
>
> Feel free to take it through the perf tree.

Thanks, I'll add it to perf-tools and send out to v6.11 later.

Namhyung
