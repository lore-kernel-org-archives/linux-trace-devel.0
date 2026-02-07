Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A02C238D22
	for <linux-trace-devel@vger.kernel.org>; Sat,  7 Feb 2026 05:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770440655; cv=pass; b=Ryj7I7ZjOJb6Jauv41DQw4u6su9AAcOhuZBg8v0R0UdbVEBLH2QQrNHhLZdOLK4OrAxhs0z80Z1X/26jMPGwm5QBugjDSpwKLHUT1U0uUmWeujiiFacFm/HNjjyeFepXl+o5NYyQdApQrLsV8sGwWREqstbuYw5PZ4DF7yf+gyg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770440655; c=relaxed/simple;
	bh=JFH/t3VKN5v5jHx1zr1Q6nESIPN28gXYy6ldvBtiuhw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=byxQ+5cLlp0zvQTUW1rTIYCx8up3S58Ht8284gB/bxP6OSYVZwS5Fz06iuNRDi3sSqpEWyEmTW99kCf53G8SL6bBjKy1ZL2yeCnwOMusehYDIU0d0SgVDi8JkjKXiRoQKQOFUIldYYNOKRpyNWpaIloMb09Z2A7za5iI27XBbHg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SnKWIgX9; arc=pass smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SnKWIgX9"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-65956402da9so2838799a12.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 06 Feb 2026 21:04:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770440653; cv=none;
        d=google.com; s=arc-20240605;
        b=UqZ3u/c/2PbyxTf15zomWbBvOQ9fU2H9Us7P5gUIuSCnJ/AbNfRyOTpx2zq/X7Cbe1
         dfJTDP1xu3c1VQiQSSK3GMc276LOdkoLJ1hXusXSjDwbXaMC9xT4/4rs6b7YLft88W52
         SPvcTWSZohXHRI5A85MNSyfUOomA/lLqV1BXmNSuOWDxIIukZtyDiMuZOdRXetgnC3J5
         6bNATH9Ahf71mGhJr15TyaqpZAI3XMFrKxI9NSl4uMj9FeuQcih2kV1K49NCqI+e2z6m
         3f16Ji4aANRC47BqJK2oHpk5s75MIxQXgx29PPDh50ryP3cxxy/iD6p5gZceqBm6x2e6
         eG/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sIeBpZEkUcwYsHcC+BOY3XeeEGpYhknUywef2iobqTI=;
        fh=jH7Dkynkh7vdBkoA5AchX/ttsWZLBUXfkImbPCmlkfE=;
        b=cvC02JcBZKbe70WTs/kKlRPKH9tVZk58+BBKYTUV0/mn+eU+IgJPc7GLw7Y/flZAKF
         wRkdHXIcr5OL2qU7tGvE1Jo/tVTlE8jwaDnzXc25dvmKfOw8YiJ/S2VKwUNK0mHpMn+8
         9A0Rdz1pwSCaigyQq0m5926alWCSKRMXIE/sMAQm90x1llSzA8GNwGiXNQ+Y14k75EMX
         rnV75/uZr3xqcecMaI8Re1TPdSpOPd/wC06aMCmNAXrJu3bwT+l14Mx34nTR5fqX98PT
         Rc7pFItDJ1fH00IBsKMVVv6V3+WE3Y3963feMlybDjG/ox5ggy3sh2q6C+/kfQlMkYeY
         ijjA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770440653; x=1771045453; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sIeBpZEkUcwYsHcC+BOY3XeeEGpYhknUywef2iobqTI=;
        b=SnKWIgX9OXWAYMcrDYHt0JkGDtMIf1hfyWfq6lyr8iQgNpXbY6DUbWcT7946qYjvgV
         8tvv1C4o2kVysxCp7UlrFGr+cOgX4red94zSeoznRjiU+3ufbjktzH//jqFz6Ol+RXkk
         5M66cnzzt6CD7is0fNI8FwuwB445f9z8t9lWdqad/Obeu+OfjcTMXsAMsVSs/oe2NgEH
         I4EyJ7szc0pBVCiLdb7AW/MRoifZAEcmNp6bQR4ksdRirU/h5FX0/87NV6pPjUwSZajb
         6Z2AKMJdmDOoauEOFghMdR3Oyh6m4AwbMI2VYafuBM736ZSDpUqwxQ1s44VvLjo8kKxS
         AfxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770440653; x=1771045453;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sIeBpZEkUcwYsHcC+BOY3XeeEGpYhknUywef2iobqTI=;
        b=dG70TwUVh+cRnSwwwRV0onIh/qq/RmhFvdqANY+d+rZkGYWQ8WQvcetVlWbeeLj4AE
         i/113kzq3AeDBouxaRdwKjRmg9uFp9S9S/D3E0WV1syg2lS+ksq7Bc+GMjYK2+Exvjb+
         a/0v2nAxxZJ23pPtiY9lQk/q/lfSO7ZyugBDVyLdb75Aqn5fkgIK0bj0khqTkfBukP0d
         /KkQr1eCBRotndJSGzWiwPg77hHZ9G9koh3VT2WGao2Nj/LAKGBOVMnvEuVLJjrcGS0b
         y7MaGeH/f5C/1j90lWalGWaAQ0cjCNad9xOT0l3j1LkUjfns5d8rEXauGHQnirQVE0bl
         6KSw==
X-Forwarded-Encrypted: i=1; AJvYcCWpidptlmzrdVKpruUerwyxwI5OtTFpsITe1DUWgAlP338Ea+XRMp/z5Uafidg6D0KqnjyWnhlKJrngGDQ6jRn0Ug==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywl4mJxTIXUMcuEgK1VDpbh73yY9bRd9fJhUft4KtaBvYxO1V/A
	rlF68aYQ7a/UAAdQAS95w01YYTOt3ApfOKJc+NcCRSBGzrTQbZZyV8gz6P/PUDzCzOhPA1rEHok
	SaRdchdTBTNhO7cYpjjZggVqkJEwHGcw=
X-Gm-Gg: AZuq6aL0/6hW0dXqWqbRb4KUa+E0Ti2p/H2SY7ERdA9bUQzT8oNXCjY/tCVw6boEqJJ
	CZgzn1fzemCYiWHSh8PmHVtUclJ7LEMjV30HYfUf5JFJ669qW4leV6X4VzEdp214uxv3k/5ejcc
	Fp0P5aJMbdyQD4Lx16tV5cyYCvUXiZDqbPPFEW2RE5os7VzIRfEJJUT/s7G9YLgGltV3kBJ35+R
	3kcgdTWiqXFJfEyY/IIELPSnd3YU/dpQ6J9FaApRvk9fY3VoLLYr/9CFGOL3IkCsuLTEZDI
X-Received: by 2002:a17:907:930c:b0:b88:227e:3876 with SMTP id
 a640c23a62f3a-b8edf228a3bmr279082966b.24.1770440653218; Fri, 06 Feb 2026
 21:04:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206091512.2127246-1-dolinux.peng@gmail.com> <20260206100211.78193ec0@gandalf.local.home>
In-Reply-To: <20260206100211.78193ec0@gandalf.local.home>
From: Donglin Peng <dolinux.peng@gmail.com>
Date: Sat, 7 Feb 2026 13:04:02 +0800
X-Gm-Features: AZwV_QhDoUeMuGKvLcZ6Es-t4YqP8_qMSDma-k7e4EIQsIwboYVlmt55pf1CQcM
Message-ID: <CAErzpmt8EQXD_noaR+gsBaAV90xAQSMJ38BgBd_8r-Q_40-abA@mail.gmail.com>
Subject: Re: [PATCH RESEND] libtraceevent: Pretty print function parameters of enum-type
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mhiramat@kernel.org, linux-trace-devel@vger.kernel.org, 
	Donglin Peng <pengdonglin@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 6, 2026 at 11:01=E2=80=AFPM Steven Rostedt <rostedt@goodmis.org=
> wrote:
>
> On Fri,  6 Feb 2026 17:15:12 +0800
> Donglin Peng <dolinux.peng@gmail.com> wrote:
>
> > From: Donglin Peng <pengdonglin@xiaomi.com>
>
> Hi Donglin,
>
> >
> > The tep_btf_print_args() function currently prints values of
> > enum parameters in decimal format, which reduces readability.
> >
> > Utilize the BTF information to resolve enum type parameters
> > and print their symbolic names where possible. This enhances
> > the trace log readability by displaying meaningful identifiers
> > instead of raw numbers.
> >
> > Before:
> > mod_memcg_lruvec_state(lruvec=3D0xffff88800c18a540, idx=3D5, val=3D320)
> >
> > After:
> > mod_memcg_lruvec_state(lruvec=3D0xffff88800c18a540, idx=3D5 [NR_SLAB_RE=
CLAIMABLE_B], val=3D320)
> >
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Masami Hiramatsu <mhiramat@kernel.org>
> > Signed-off-by: Donglin Peng <pengdonglin@xiaomi.com>
> > ---
> >  src/trace-btf.c | 20 +++++++++++++++++++-
> >  1 file changed, 19 insertions(+), 1 deletion(-)
> >
> > diff --git a/src/trace-btf.c b/src/trace-btf.c
> > index 859b0860ce2a..85f5fefb4d3b 100644
> > --- a/src/trace-btf.c
> > +++ b/src/trace-btf.c
> > @@ -32,6 +32,16 @@ struct tep_btf {
> >  #define REALLOC_SIZE (1 << 10)
> >  #define REALLOC_MASK (REALLOC_SIZE - 1)
> >
> > +#define for_each_enum(i, enum_type, member)                  \
> > +     for (i =3D 0, member =3D btf_enum(enum_type);               \
> > +          i < BTF_INFO_VLEN(enum_type->info);                \
> > +          i++, member++)
>
>
> You can make the above into:
>
>  #define for_each_enum(enum_type, member)                       \
>         for (int __i =3D 0, member =3D btf_enum(enum_type);         \
>              __i < BTF_INFO_VLEN((enum_type)->info);            \
>              __i++, member++)
>
> Then you don't need to pass in the counter "i".

Sorry, I found that the previous change causes a build failure.

The error occurs in trace-btf.c:36:
warning: initialization of 'int' from 'struct btf_enum *' makes
integer from pointer without a cast [-Wint-conversion]
   36 |         for (int __i =3D 0, member =3D btf_enum(enum_type); \

This is due to the member variable being redefined as an int type,
conflicting with its assignment of a struct btf_enum *pointer from
btf_enum(enum_type).

>
> (also it's good to put parenthesis around "enum_type").
>
> > +
> > +static inline struct btf_enum *btf_enum(const struct btf_type *t)
> > +{
> > +     return (struct btf_enum *)(t + 1);
> > +}
> > +
> >  static const char *btf_name(struct tep_btf *btf, int off)
> >  {
> >       if (off < btf->hdr->str_len)
> > @@ -546,10 +556,11 @@ int tep_btf_print_args(struct tep_handle *tep, st=
ruct trace_seq *s, void *args,
> >       struct tep_btf *btf =3D tep->btf;
> >       struct btf_type *type =3D tep_btf_find_func(btf, func);
> >       struct btf_param *param;
> > +     struct btf_enum *enump;
> >       unsigned long long arg;
> >       unsigned int encode;
> >       const char *param_name;
> > -     int a, p, x, nr;
> > +     int a, p, x, nr, i;
>
> And the above doesn't need to be changed.
>
> Thanks,
>
> -- Steve
>
> >
> >       if (!func)
> >               return -1;
> > @@ -628,6 +639,13 @@ int tep_btf_print_args(struct tep_handle *tep, str=
uct trace_seq *s, void *args,
> >                       break;
> >               case BTF_KIND_ENUM:
> >                       trace_seq_printf(s, "%lld", arg);
> > +                     for_each_enum(i, t, enump) {
> > +                             if (arg =3D=3D enump->val) {
> > +                                     trace_seq_printf(s, " [%s]",
> > +                                             btf_name(btf, enump->name=
_off));
> > +                                     break;
> > +                             }
> > +                     }
> >                       break;
> >               default:
> >                       /* This does not handle complex arguments */
>
