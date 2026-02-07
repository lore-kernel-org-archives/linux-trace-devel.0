Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C552DCC04
	for <linux-trace-devel@vger.kernel.org>; Sat,  7 Feb 2026 04:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770438508; cv=pass; b=Ivn7cMOyiPeHXgETpApcR5iSqupAcfpi8QPi06QW8qMRHcrfTz9uLVuV49398k6UkEHl0+I/1epEz7nLrClUtGJqXw7E/21HEDmJn1IK0qTToDJQVPPMF2FX7QmlHXJjVfmPZp5T2eJ6SqjDpyNTBvlaPTCviKXeqn13TcvecDE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770438508; c=relaxed/simple;
	bh=V1m45qY6wPrOjRj0A0ZktMcpefXM72SGNIb7cPr5WyI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Irxqs+N8Y4BtKA/cPAsf3WQeStJwxXsg/e2QxEc+Qm6J1we8ksrFK98Ni7pfa+3dzxu4OEwZjSS/i9s/oT3JnOS5HPhQ16dSWOoF8Crgs7VTBQHqZsj8PtjHjRU837e02eJZvqTq4/2y8+ajIkyF8FvbNg7mz6SXnFIjQcOj2/0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EIl/Z1T6; arc=pass smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EIl/Z1T6"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-658ad86082dso1826434a12.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 06 Feb 2026 20:28:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770438506; cv=none;
        d=google.com; s=arc-20240605;
        b=SZixC/qjtmVQC6MwkWlexAyQMaLXTpeCB6vtGYZQshszeqXSzg8iyvWYqcOunj6ph4
         L5D9d0RsWRkzgpN8wSbMzSehQB09zac1ZmJ0uqPNz/IT4HU6yMAHxrqjtDldIDnkYdJV
         pgbIRJCZkmTbFBQPXNP+61lBCJG6Th/r2v6DNIfmxwNUTTV0liKe5pPIsJCGmBz3Gz2d
         M4C2x27NuShtKJU+Mrj+BpYEOvByPzPs+7nKjO/m1rOc6TmC+Xsv3WOT6gsxq082UREq
         3Jo6dAm3mY0zsscClD+ap3apYXP0j2wJ/mXIOvyBf6fpxejL7KbMQALuAJOdLfudBQ9y
         FZog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LzAT5q+KkVVB6F2btvJMpdPFAfmiz+TJrBtNBPA1SWc=;
        fh=52AWfkw++iU5tTdMLNB84TC1XYbpYlQ3HquOeQvb94U=;
        b=YbkIy17H6bxNDYwzfjxPhXKiWE9gJBo+3V9HY+1UAuEPO4v4P6NY16CC/gelDh4n8l
         SBUm2ljy0AuDNMtsHQy/oHtUlG492/Xl/naNIGaf7VFiHrf4WZJ0r7j4iXnt9HSJgBSg
         yfRJ/07FhOG/oEISd0fvqq3LOewCCLG5nSdeZBLrx3W5j2jMlB2ibPko7lQ3igH759da
         2gsqq7HTrykNogRJhnFbyqE3m+h88HH3M7bqylSBxOAMKQkBSwTRgUEPOaqI4D2OcWPk
         BF16uOqnBNf2Tc/0w1xr5bBjuq5AKMEMmg//gRPRr/7y/BTzOkNFrHQbCtbr/KeqyBW1
         0AeA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770438506; x=1771043306; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LzAT5q+KkVVB6F2btvJMpdPFAfmiz+TJrBtNBPA1SWc=;
        b=EIl/Z1T64iUqA2RAUU9qsA/3rt4bAACwl1Rlxpz/5ZsPrlXUY4ylU/T2QqKEqzzZLA
         /o+vVzmb7Mp+t+11ls6N0fDdU1kKcpohmGwxRU1mtejor6NEEjbvv0GNghj1iezOHuNB
         tuhIaVA8AW5lxVH57CbvRKKYSa6o7A1P3+c6QQnBdWxTHsOfdhrbhvk1HHzgqAjOjxpb
         uVYLQe2h4OJllNIGVBxGbDUg1zG+hF2kig0b29Twd+y1AU8wPU5rV+0wbHhJ+uoffQYw
         4pwZrlwfp8CV/09C3m63pIBvl6NGgQ8wbyNwRk8KZDg+UvB2TkW0NsZa9bIDSqDzmrnn
         HApA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770438506; x=1771043306;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LzAT5q+KkVVB6F2btvJMpdPFAfmiz+TJrBtNBPA1SWc=;
        b=Macmojw01oQNaVD/gR7Wdb3/8M1GMnKJ0uKdrsHn/IeAyf2QTAAUklzPj/IZCx+I7Y
         hB3OfMZCX+b48ITHcWmHw4RH/NVoSxI3GH70StRN1ct1vOLhqgOQaykn0Iewx4dMtVIE
         ogDDIk94jAsSJxEY2Wrs7Y2KWfBx5BEetHTPqC4sQAeE82bLJfF5XW4BAGshj1dvJ1t0
         jJbsQ4YWXkU/IAwTyM3xa7f+bLcru75SconDFZTKuwFCZfJBoan967hp/Oh4MuGjT0qu
         7u7pa13dz1NRlpyX/UTDFK7r8JSdvyRX/BptWjeG1VgASrVPv2qGUaqd7EvXNTX+g503
         jtnA==
X-Forwarded-Encrypted: i=1; AJvYcCU+N6GhWUk09hke67EzosBotCcXAjTw5Sx7kxlZjgj2jwjm1M5GJ89KNbtKN58/BF2clBUf2mc4BJf7HdJ3visSiA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx92DvQ7XvAefMFit/jFLSAemFJ4TVDsHhrdWmGF0w8o2zn8e0n
	oZp/g1sn+7tdA23FAehUKPQxv0oRV4z/U6GqGWu+nLumy0fPdNlWuHz2fm5137P3qA0sHGfgT5t
	s9eGIo6reFbFm3ILuwdjLY5nFZvAU/ss=
X-Gm-Gg: AZuq6aJD8YRS/gbnl0m7ecNrZPSDYE9R985iP6pJgUwGIcQQxKBv1HIyzdCT3+o4/3x
	b0kpxrUYu8KcO70VbSq6rW9/H8nnHlssMVRvUdVli/r2fdI5OGwlXsJ1fNhCupCa1plJlXIe+rI
	1BVRWjJM8zbvDRJv8qgQvA5vsuYyZn7vSIyFpKf1YhYv1vRyJi83/q17qIOKEzRtlGnIsE+1dm1
	5sRKf9KRUv0d0h4xqZyHt8GolO1/FYVNhl4em8MurdWPRjjvfTP8r5KwLvCG1kzJTDGdlEg
X-Received: by 2002:a17:906:d550:b0:b84:2075:b902 with SMTP id
 a640c23a62f3a-b8edf2f9c23mr240337366b.36.1770438506241; Fri, 06 Feb 2026
 20:28:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206091512.2127246-1-dolinux.peng@gmail.com> <20260206100211.78193ec0@gandalf.local.home>
In-Reply-To: <20260206100211.78193ec0@gandalf.local.home>
From: Donglin Peng <dolinux.peng@gmail.com>
Date: Sat, 7 Feb 2026 12:28:15 +0800
X-Gm-Features: AZwV_QgeMQpFxPpVWGOi7knNcUUu3ZoNot6xS4ED_WYwzPuIxzwZP3mhhZsSNI4
Message-ID: <CAErzpmuPy2t0WYFoFk13SN5LsRYmQW4Lf7t6b4-WCRGyt_wpLQ@mail.gmail.com>
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

Good, I will fix it in the next version.

>
> (also it's good to put parenthesis around "enum_type").

Thanks.

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

Thanks, I understood.

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
