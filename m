Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBCD02FE57B
	for <linux-trace-devel@vger.kernel.org>; Sun,  8 Feb 2026 12:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770552189; cv=pass; b=ViHLJPv5SnPl/tXaQgiAlSVtjbWpphOH4+Vmqmsx1l/Yi/DgzHOIHbN4HYwv5D5lm3FQfIqQEMr34sGp65OCKE8RXzaonDJFOqLTKWUnPZK85SgzvxI/Ec3W0xKdskzuk8A3LGZwUYrXqLk3yzLb8sMaCYhCnuIfMWyTDve6QmI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770552189; c=relaxed/simple;
	bh=wKJ/SYSGbJHcvRrLjm7/R0Zm8PRi8D5247OnTO93NhQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SZ8t16Ac6W5qhLAB6oImfDeBrdSTqow/RcO22yEX8w4NZ93ATFSDFcNyHQ9qiBmX0myziSY2lb62RDD1xx3zCXIwuFlZS3viKQDpFrKVxBg1Z9ZR7N9JyJxdJBdKxy2x/1rHmhU2ELQeruhc7nadKjy82J5Qi8rfAqrpgqvVadg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eACJz0ec; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eACJz0ec"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-658b6757f7fso5982404a12.1
        for <linux-trace-devel@vger.kernel.org>; Sun, 08 Feb 2026 04:03:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770552187; cv=none;
        d=google.com; s=arc-20240605;
        b=ian7nWYJjqkkVphT2mtHOLg4DWUBY5K8i1tqfr+PtMfjVZ1O5ONqt4Oc1iWxc4l21l
         Wnet4jCfxx1H41oKGOMwswCdYa41SSsJ6PzuKMWBfpKi6kg+q3nt0OD6DmT2rWCjCHvO
         Xuu8AtpZXV1FGm2BQ3BWt4S2px/svlaD6qT86YtlVumrLE/d/hOT2KeeI1UvzkU1uDy7
         JJ1Sd/9i810JzE87eAjmN6/7S70VGrMndZThTxyoOP7meYqQ/sganb/NaZU5ki92fU7P
         pkvkzcyA6CtFGWKW0UD/DVqa39nKU3h3kjjhqNzK/2WvNds+JPtaZfL9SyfQDr7gzSR0
         b4HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=l6UuuI/JNYHq0vfN4KIs9mABs2bzglO9MstKOXOZ+ik=;
        fh=q+PDVs3qd+Wl6LrbesczUak6Bncq3UKgWZ4ixQ6aASs=;
        b=g27gMHnc4UOVqVXYFBuWlXOEnvAaaNOnggd3nou+THNOtYIlNlSYP1KDG/ZO3cUT15
         O9lzo6kesq1/mUEol8OfCs22rhSDC7XQ2XVlIBhOzJrhU6K41kqAEBU18BbswcdiACuB
         M9Wb5siJNcC+MLJTHVbuOT7XBJj/rXWRKy1H2+ZKodS6wc5JYfFfHlfUJ6Idx9+SiClN
         Z0ce72X+Cx1Y9kgOvpHjK+tFD5rb/0DqdvffGa7cJ/pmdpoCddfcAhRQHSzD5EN4NN+O
         i8l0lJHrWjt5EITC3vqy2UKs+AiYlB4yH/W1dGLzuGIArPsTuYHy6dkGx2WlWHWFFE/Z
         uiXQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770552187; x=1771156987; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l6UuuI/JNYHq0vfN4KIs9mABs2bzglO9MstKOXOZ+ik=;
        b=eACJz0ecTj39kVKZG/OdgQCfwORP04hmXMi+IXOBXrAvVxxcF/aGK0eFLGOT1HNUF1
         IAIhpEsXNmHZjV2zN7BLAjYPls+U4JJS1v3zkebv4DuH1bIxMAfAk6QQ7aOWK97r+9Xc
         sy8/MfRq/2+R2i5NdMrexYyLHsGWgAz5o5gAqoG5NRQ1b7PMF8KJZzU5Sk0QEPcHM3aG
         SVWrUkYYvMsGn2V00IqWlvuedA5mNtQb/YB03RupfMmQRjo1xU/R2bjEahk6rfKn/Z/C
         R1oVQf+0hIV+Ws2bv6/Sgyb99VfHASAlgQqV+ghgSzgC6Dfrh7A7qnTbtfWg/m3irZXt
         lxZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770552187; x=1771156987;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=l6UuuI/JNYHq0vfN4KIs9mABs2bzglO9MstKOXOZ+ik=;
        b=bspof2Nut1lLaRSlWTM/wtAOQBDJjRF/czS9OVFVeI2cTrhtCtqYKHnw2zVpc0vai+
         iJG2WC/1XJ53qLoLCWd8uDh9wfAFdRdWxlj2QSVt3bNZseBL3Cqw2bZVNgwQouD74kiV
         oow6QnBeyv1pNLavstsnBQ/e4D1T/EL2MmTace0LGx49NMxMY0XnmWNYDt1FvI1eOT4p
         EdJimmW3AeDPX4hmQn7Oa3ehzPSTcK2RezPOmCbaM7ebjBZGyq8qhotVD6m0AtlG6RsV
         QzqHF19L0eHrCYNV4QNGmL2doYLndAfe6EO+w5Rq+T9naCxbTdle8U1dfOXYuYgxs9/5
         ving==
X-Forwarded-Encrypted: i=1; AJvYcCUeWaoB5Fnmoe/W9kgjwwH0mCShcrOMOot30ewT7BmZuEdhxbP/V1KPkUjYEPdIYULftR6v9JWyVxZPbSipzkWZMw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzM/KwS4IWzYaDqfiKBGhIvql4NGORZURzhzgR9bCoSBv933hD5
	LRXxCs/dGW5ZjZoiEl1/WomEnMZtvdbLM6c39FqQdIn9NUm/FfvwR92EVdQzAn0h1WVlq7j8NrL
	XtdiuPY9dy4ypqBkh59+fFH772PAZjsk=
X-Gm-Gg: AZuq6aJQ9TD/gYtSKvu6aelkeyesn72c41Ax7ucROZHUdvwloO5/twZjzVqKA6RVLUu
	p+xgAPOGP9ubLTuWOIAfISZ5qDTto+rUozyX/tOuXhzo+2GVauw+4wifxxJSo3YZgZv1M+vTUtC
	vJd2OO7OxicFVsTWDQkS1eif0rlEqr/XWMYBNgi85V9GiXBBL9od2iW6lhXFctIDRELlzo+WVHm
	JFoZL2zsXOgzcaxUdMngZKmgWRYtb0nGboeHZvGDvpmbI3kz8T2NXMzmK3YcbDrBsN2VC6zVoG0
	P+jAhBA=
X-Received: by 2002:a17:907:6e9e:b0:b88:50ea:f64f with SMTP id
 a640c23a62f3a-b8eba0e10dcmr768803566b.11.1770552186770; Sun, 08 Feb 2026
 04:03:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206091512.2127246-1-dolinux.peng@gmail.com>
 <20260206100211.78193ec0@gandalf.local.home> <CAErzpmt8EQXD_noaR+gsBaAV90xAQSMJ38BgBd_8r-Q_40-abA@mail.gmail.com>
 <20260207091612.2bb72f61@robin>
In-Reply-To: <20260207091612.2bb72f61@robin>
From: Donglin Peng <dolinux.peng@gmail.com>
Date: Sun, 8 Feb 2026 20:02:55 +0800
X-Gm-Features: AZwV_QgeLpq8oJcE1r8RQ3f6ZdnAxEr7XXGUi0XV6DpWp-USUa_j8lLozWb5fIo
Message-ID: <CAErzpmuGSUJVogLgY3gu+e5=1qJohoga49t0w4hkkgRVoV7yHQ@mail.gmail.com>
Subject: Re: [PATCH RESEND] libtraceevent: Pretty print function parameters of enum-type
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mhiramat@kernel.org, linux-trace-devel@vger.kernel.org, 
	Donglin Peng <pengdonglin@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 7, 2026 at 10:16=E2=80=AFPM Steven Rostedt <rostedt@goodmis.org=
> wrote:
>
> On Sat, 7 Feb 2026 13:04:02 +0800
> Donglin Peng <dolinux.peng@gmail.com> wrote:
>
> > > > +#define for_each_enum(i, enum_type, member)                  \
> > > > +     for (i =3D 0, member =3D btf_enum(enum_type);               \
> > > > +          i < BTF_INFO_VLEN(enum_type->info);                \
> > > > +          i++, member++)
> > >
> > >
> > > You can make the above into:
> > >
> > >  #define for_each_enum(enum_type, member)                       \
> > >         for (int __i =3D 0, member =3D btf_enum(enum_type);         \
> > >              __i < BTF_INFO_VLEN((enum_type)->info);            \
> > >              __i++, member++)
> > >
> > > Then you don't need to pass in the counter "i".
> >
> > Sorry, I found that the previous change causes a build failure.
> >
> > The error occurs in trace-btf.c:36:
> > warning: initialization of 'int' from 'struct btf_enum *' makes
> > integer from pointer without a cast [-Wint-conversion]
> >    36 |         for (int __i =3D 0, member =3D btf_enum(enum_type); \
> >
> > This is due to the member variable being redefined as an int type,
> > conflicting with its assignment of a struct btf_enum *pointer from
> > btf_enum(enum_type).
>
> Ah, I had that issue before. But this should work:
>
>  #define for_each_enum(enum_type, member)                               \
>         member =3D btf_enum(enum_type);                                  =
 \
>         for (int __i =3D 0; __i < BTF_INFO_VLEN((enum_type)->info);      =
 \
>              __i++, member++)
>
> Just can't use it as a single line for if statements.
>
>         if (x)
>                 for_each_enum() {
>                 }
>
> But we shouldn't be doing that anyway.

Thanks. I will do it in v2.

>
> -- Steve
