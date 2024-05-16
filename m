Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF9A15820F
	for <linux-trace-devel@vger.kernel.org>; Thu, 16 May 2024 22:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715897394; cv=none; b=g5JrurUUp6bnceR24BLAWm0OstMTZ1KKXCQiWEmxQkHgUSqWQ6gdfFELeZpMDEonfZN/pr2wo5Nu8FVcTrHqOxVxzOMHzLl3fmTno9A7BTH0KCtQ1w/lL9yatjEsCxgV7nHok5GBGL5ecLSVD9W4xd6XcejuZlBQU+mN32NNCVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715897394; c=relaxed/simple;
	bh=TtFZcj9fpoXLqpqJEGKDPaA2BkIvaOi5Um6DNfTKDNA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oJEFwUo9VIeF83Fj/YObTLN/Zm0Y37eTd5yvg5AMsgaN3vs8LnGzjvgRbmRdI565Jf7PzCTusZFhcqldA1wqpVSKv6lEftZsGODVN+7snFf4cp6r3jbueEvoXl4CO2uXMQd+aArpwQgvX6pdFPbkklTCvoCgQHjeT93SilSz13A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O3VSsIJk; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O3VSsIJk"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-43dfa9a98d2so4541cf.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 May 2024 15:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715897392; x=1716502192; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8tjbzu+eyrlrr78pEpRe1UTlykt3VsZwm1vg4xJVl0s=;
        b=O3VSsIJk0Fm5rIR5qvRQkgDvwmuDWVv7GLqEKmPrLu3qIe61P9I5NdJeIQpY3EXLYH
         eNDYmnInB8nW5Zjzna/DQHd1P6LOe4tFohmiPs6dFY5X9HWJsw4l5unwGe9uA7Djmiup
         hDbWcamhXcM5k9waoAZym9gc5B2258dH1T2qrQQ6fHcwJKrbQ5Z3wPs8FmG3iupFWy7q
         uLZDLDvyNYDFL6nlH3AmFb3k2PTjAVM5uOEMOY4nTCDn/tWgwlFHIkhPC2p1W1PDDy5d
         eMgVq1YrCp5J+SV2aQZzjPtPL/eIlYI/+naz5++DMoLcXRLz/u9BABf6ZAt9Kg8yjf+z
         uD5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715897392; x=1716502192;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8tjbzu+eyrlrr78pEpRe1UTlykt3VsZwm1vg4xJVl0s=;
        b=aGLGH/8tFvj5LqU/VUzJjnqS0AgbJs16/qg5gscbYx0MkDNjlussQ9mZwRYFeOTbOn
         tzAnztmZQa3xVFBO/1oQtV1oeWEVGRG939C/Qn7y8UBlqa9Vzlk3bGSJ8GbjxvbADHbG
         itIgDCfJDNccrcyHGEbjDKQY1oqfU91xX4HUllN9IG0PAFb0+OVy59g2Th489uVQw4AV
         2e3KWpHmrojh4wsaNpivObGAPmzdg3Bts4vrdazE47mKHlrpDjnKAMY00zn9xOIQQePW
         tP3PnTssLADWGVS0Bb7pVNmsf89XEklrSwZrSduFsnW3x7nnwj6vBpF/ve4tG7oZ1dKD
         5Ohw==
X-Gm-Message-State: AOJu0YzfQ3QogF77ui5qxXUoGK42hEp+e5q3AUhfTVpiaFTSvWsD38kg
	qA69Yxsu/mCJzPeGK1npRW1CELIq6RC0jlP8YXpalyYEmFswIQsRCoBXDRenkGfnzQdJPgWiEf5
	e3rY7N8diSQ3FD7oBaO0rJHU9Y9xmn5foUt7RJ5YrfRbR1M42nIKR
X-Google-Smtp-Source: AGHT+IF8pbsQjZolOf+34Ru/GlYQ6eSMbb/bIspjiGFfYKHeklstwERoFz3FkWxHZ8j0le4CnTPETw6uy2yEcwuaRKY=
X-Received: by 2002:a05:622a:5888:b0:43d:fce9:684f with SMTP id
 d75a77b69052e-43e440d866cmr1131391cf.10.1715897392033; Thu, 16 May 2024
 15:09:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240509051317.1913001-1-irogers@google.com> <20240516180248.24aa5aeb@rorschach.local.home>
In-Reply-To: <20240516180248.24aa5aeb@rorschach.local.home>
From: Ian Rogers <irogers@google.com>
Date: Thu, 16 May 2024 15:09:40 -0700
Message-ID: <CAP-5=fUYxxmH8X0RVhdSWzKFT+WJO_UDULCtO4PK+VO-osXwGA@mail.gmail.com>
Subject: Re: [PATCH v1] libtraceevent: Avoid a simple asprintf case
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 16, 2024 at 3:03=E2=80=AFPM Steven Rostedt <rostedt@goodmis.org=
> wrote:
>
> On Wed,  8 May 2024 22:13:17 -0700
> Ian Rogers <irogers@google.com> wrote:
>
> > Avoid an asprintf for the single character TEP_EVENT_NEWLINE and
> > TEP_EVENT_DELIM case.
>
> This states what the patch does, but omits why. What's wrong with
> asprintf() here?

Nothing except overhead. I was tracking down an asprintf issue [1],
asprintf breaking the sanitizer stack traces on my debian based linux,
and using asprintf for the sake of copying a character was creating a
huge amount of noise for me. 2 lines-of-code extra means this change
is by one measure more complex but it removes special knowledge of
asprintf return values and the meaning of %c, so on the other hand it
is less complex. I won't be offended if it's not accepted.

Thanks,
Ian

[1] https://lore.kernel.org/lkml/20240509052015.1914670-1-irogers@google.co=
m/

> -- Steve
