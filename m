Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A8C23DE
	for <linux-trace-devel@vger.kernel.org>; Sat,  3 Feb 2024 01:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706924530; cv=none; b=mQReNRc7GBU0dGIYpBXUBOsUlSw5/iW2wRr42KjE+Yk7n2C3NFYMq1FIVUJTxCjBCyNiDtWzQMqGRw1TXIowQGod+zy1dneS8k4tBGnUI+dJOG8Efmqu7m8P7axHhNsQbofAAKylR9czpYn0wswxo5Aj43QwPwNsanAZu1cL9NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706924530; c=relaxed/simple;
	bh=GL/NWsRNvwetg0ZgKm/CnIK8EZZYE3j8znwpXi+d+6k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Uy6ATtFkVxzLddvASQ61GZcOGZaf6v9eFUlpSH3wBkX8uOmEsyQvkp+3nnxe8uuKVqTzEaBx6ghGc7M/eTRQqSux2d/iWoH2dzD+X8sMLgH7jCU/Cenl43FlnZN2XvGgbw7UGFWNwVQl61teFZ+A1LyemF20lEBsocQbL1EV49k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D/WBXHhD; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D/WBXHhD"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1d5ce88b51cso101585ad.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 02 Feb 2024 17:42:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706924527; x=1707529327; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W1tmXsSnp3camgDs1JiIWN7PNv+Db/yDFJhwZXZV06A=;
        b=D/WBXHhDzyKrowiHj1GMrP31KK5M/OAnZsRTqSjBT438hdoJcLSiMQ8wGVoWjgBEKb
         lCqzFLtXIHtrY/fuIhFYdy+9ledBCKhQMlPPMHMH+TAqoLn6kucLBW7aSNQsKrhLMYt1
         Jv3iFm51hQ73wUqAkAJHa0ny1D7Bpbi6CkwhBeB6MlVKjcfzPtCP1doz/PL5F+iNR7yw
         sK7QmlpUtBRuLPsuGZ4V/avM0VafKTgE+2A3gKy/vcq41XqLN5dCFc+XFh++Ig+R8JFr
         9zI7SgNHzXOi/iFdWHAr+5vI7aVXesPoluqm87X8V8kiqHPznjJ7/SF0Pn0FnbKAWaNy
         TG3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706924527; x=1707529327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W1tmXsSnp3camgDs1JiIWN7PNv+Db/yDFJhwZXZV06A=;
        b=PUgsBy4JshzBbBNqCH1Wvv6FEjF2j6JNdDrVwKTIwOz5X6O9bzhkYSB0wRh6+LZ2pd
         mm1Y90Y+bNwRm/zvX1rG1+vj9fup1ZEOIzvSeTnFrwtaCCOVXCZnBUHRIzbSss+LUBoJ
         HC/gmXzy1sZrsCkal9z45M2/PPdcICsxF5G5AgIdUzs41ANCUViMNadVvylhQtgLjcrN
         6Ep7xrbyJwa1cNhQksMwLMF+GMDYW5AhLU0oC/Rs59KrEBp6wU1mNFGm8C/LPJyErJtt
         IIRIRpp6+DC8KHwEPdsec5aNzOYGbuWFdWvsGfrm6oJc3Ia+N9w/CliVlyYol3UbfLlx
         UEqg==
X-Gm-Message-State: AOJu0YyBofjBChu+9RNTbdjRM8/4zuzntxmwBw45Xyh0InywUQlDf4+A
	qr0tcN/iqxxk9nmZfcMXwMdz/StWEzZD3bmToReIqZu9XpZat/PCLuLmNyLMlDh7ZAv+mCMoNNp
	KdjXq1hhM92REWXIHAminA+ii7OPbhu8OrnHY
X-Google-Smtp-Source: AGHT+IFvVXrppMHSh7EsMSe+LktgAY1bvnADV80hP2rmsBLFLZkqA4D0C/pdQHOx+A5VfLjdqqxNYj4YHwkYqewRHaI=
X-Received: by 2002:a17:902:b489:b0:1d7:48ef:e239 with SMTP id
 y9-20020a170902b48900b001d748efe239mr72459plr.18.1706924527056; Fri, 02 Feb
 2024 17:42:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240202220459.527138-1-namhyung@kernel.org> <20240202220459.527138-5-namhyung@kernel.org>
In-Reply-To: <20240202220459.527138-5-namhyung@kernel.org>
From: Ian Rogers <irogers@google.com>
Date: Fri, 2 Feb 2024 17:41:55 -0800
Message-ID: <CAP-5=fU=P-ib+n+OfqJAbm8gS2RY-W-KcBskoSHkC+aCmXYcXQ@mail.gmail.com>
Subject: Re: [PATCH 04/14] perf map: Add map__objdump_2rip()
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@kernel.org>, 
	Adrian Hunter <adrian.hunter@intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-perf-users@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Stephane Eranian <eranian@google.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, linux-toolchains@vger.kernel.org, 
	linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 2, 2024 at 2:05=E2=80=AFPM Namhyung Kim <namhyung@kernel.org> w=
rote:
>
> Sometimes we want to convert an address in objdump output to
> map-relative address to match with a sample data.  Let's add
> map__objdump_2rip() for that.

Hi Namhyung,

I think the naming can be better here. Aren't the objdump addresses
DSO relative offsets? Is the relative IP relative to the map or the
DSO?

Thanks,
Ian

> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/map.c | 20 ++++++++++++++++++++
>  tools/perf/util/map.h |  3 +++
>  2 files changed, 23 insertions(+)
>
> diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
> index 54c67cb7ecef..66542864b7b5 100644
> --- a/tools/perf/util/map.c
> +++ b/tools/perf/util/map.c
> @@ -594,6 +594,26 @@ u64 map__objdump_2mem(struct map *map, u64 ip)
>         return ip + map__reloc(map);
>  }
>
> +u64 map__objdump_2rip(struct map *map, u64 ip)
> +{
> +       const struct dso *dso =3D map__dso(map);
> +
> +       if (!dso->adjust_symbols)
> +               return ip;
> +
> +       if (dso->rel)
> +               return ip + map__pgoff(map);
> +
> +       /*
> +        * kernel modules also have DSO_TYPE_USER in dso->kernel,
> +        * but all kernel modules are ET_REL, so won't get here.
> +        */
> +       if (dso->kernel =3D=3D DSO_SPACE__USER)
> +               return ip - dso->text_offset;
> +
> +       return map__map_ip(map, ip + map__reloc(map));
> +}
> +
>  bool map__contains_symbol(const struct map *map, const struct symbol *sy=
m)
>  {
>         u64 ip =3D map__unmap_ip(map, sym->start);
> diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
> index 49756716cb13..65e2609fa1b1 100644
> --- a/tools/perf/util/map.h
> +++ b/tools/perf/util/map.h
> @@ -132,6 +132,9 @@ u64 map__rip_2objdump(struct map *map, u64 rip);
>  /* objdump address -> memory address */
>  u64 map__objdump_2mem(struct map *map, u64 ip);
>
> +/* objdump address -> rip */
> +u64 map__objdump_2rip(struct map *map, u64 ip);
> +
>  struct symbol;
>  struct thread;
>
> --
> 2.43.0.594.gd9cf4e227d-goog
>
