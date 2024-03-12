Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87439AD5C
	for <linux-trace-devel@vger.kernel.org>; Tue, 12 Mar 2024 04:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710216753; cv=none; b=DQtDubu9BcqTLmGtoudcbz4olVRTnbmV80dkyfBLaAyA8agLD3aI1PKYrNoDQPy4v8939TWfVuvkaBN8b9Tz36CaEJ+d2Kc0bZZmsxn7Vt6Ey2VXjXVCYedNcjUErnrnzr95P1iAVoVeCfTfgRieWnjYbRL+8Z+jLE1ymJem668=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710216753; c=relaxed/simple;
	bh=JkKCKPNRtSFXX0yoa8bgImdRevkSAqFDrGOGKQG6AOM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bTKJmV6xmXcuImQxTfomCnIoVySH6UEhfMKH8TU2CZTXK0C2anlDRJatDGv9D+Cwi3t5P0+el4ExNHyevU0msJomU8ur8EGiYBNI/hmK+wf9IIqZrP+9mSlX8GJxLWwjnUsexiZAYiyjL9M5iCw+pk+7/JWkmzbn/fNh1dflHAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PEoOmZn4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PEoOmZn4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710216750;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tO7vM9zuyjWXvYjHdFC4uAgvni7YmSPJNflT6NWlNYI=;
	b=PEoOmZn4s9ZxMgZ76DQGH3S/v9DIbNSkaBcbZJHVMq6AMuUIhfi6EKDIF4le3HNQKA/8kH
	Img3eYDwnv8+ApG6W6EXhuAlHKpCdBPDzqJ0/MGoLlvkgXBJqKJs+1m6c7gLjaUL1dzK6E
	aY5BvtIm16RANnPU7QzQEq1e3iIK0No=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-540-i44oh_EZPcWlrX8-HH2bnw-1; Tue, 12 Mar 2024 00:12:28 -0400
X-MC-Unique: i44oh_EZPcWlrX8-HH2bnw-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-56849d0ec7cso1600906a12.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Mar 2024 21:12:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710216747; x=1710821547;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tO7vM9zuyjWXvYjHdFC4uAgvni7YmSPJNflT6NWlNYI=;
        b=RT9mgcgmUyQxxyQLysHk0RVGVai0cfEiyp9SbX9kbuMUxEDsdfhlgHJUb0LflOtj0D
         Xmjrnp3SRlhlYgSt8wNkM2qOkHqfYlpTOCnGZzBTRmdLtMelhaPdwncqJDyV0+bq4rde
         ZWpg58laBO4VqevsVkW2xexMa5wulmMORG8kGDAnydRsB7q3+HD6WpIXr3WV9dYwG+be
         m8/Dh5p1Bza5DPsCvN9f0+6nXI195l5aIAiU7Dc/DecguXau6vGtR4fev0FpN1XQGlFf
         hRCGT/b7JhZQfg2ih26yVi1BFCRVBXAslJ7+cVawMs/NF2ZKfdcIYeG810IpAMe2+JUK
         0EKA==
X-Forwarded-Encrypted: i=1; AJvYcCWnLAAwtzC2O+lRIpG8QWfI0iHjTEHd8tTeKkhPSQBnw4MUBb6HHN2pqgqwmLQX36HGm+7Ld+DXU+poWaXup5Xu+7KAUY2HIdyX9qFxvI4ii0k=
X-Gm-Message-State: AOJu0YxnC04eUUsWlHcLLMvFdqm0yv5/kge6sWOfH1R2fCMr07rSDoTD
	RtBAWmXqpiL+hx0JNIcNDxYBUujXFmgPxnY4KVdrjC+UOIHWaEaoWgZYo2O2R61XlvaXe6tB2Ks
	4BhC+yJOgp4E2dVXYnJFYkkx3oMOlg8Q9rC2rwdOjPfuQQw/B5733Z64FNcBYuqWaMVYFognwHS
	JtuFjF22n6VRDdBroUslBgs9/CeL9Xx04pb9qA3edIAa625Kl89otyR4Ws
X-Received: by 2002:a50:ab5a:0:b0:568:376e:ea2a with SMTP id t26-20020a50ab5a000000b00568376eea2amr5315517edc.40.1710216747141;
        Mon, 11 Mar 2024 21:12:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHK4i6D1oCUeufew5otk6VoE44KzctpcHUn5U/+NtiwlIzgIHPS2Ynw/5QBGPsLL7J6SXsM7RJxazkYJeyred4=
X-Received: by 2002:a50:ab5a:0:b0:568:376e:ea2a with SMTP id
 t26-20020a50ab5a000000b00568376eea2amr5315509edc.40.1710216746777; Mon, 11
 Mar 2024 21:12:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <Zemv4OUx1WexdrlB@tpad>
In-Reply-To: <Zemv4OUx1WexdrlB@tpad>
From: Junyao Zhao <junzhao@redhat.com>
Date: Tue, 12 Mar 2024 12:12:15 +0800
Message-ID: <CAMZL0nYQCOOEVVR9zyxK5ZnDxPQJBwAAioZmVHB-oZr+W3W14Q@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd: support -m parameter for virt instances
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Nini Gu <ngu@redhat.com>, 
	linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Test by: Junyao Zhao <junzhao@redhat.com>

Successfully collected 12h test data from the guest.




On Thu, Mar 7, 2024 at 8:19=E2=80=AFPM Marcelo Tosatti <mtosatti@redhat.com=
> wrote:
>
>
> Take into consideration the value passed in with "-m",
> the max size in kilobytes that a per cpu buffer should be,
> when reading trace data from guests.
>
> This allows one to prevent running out of diskspace on long runs.
>
> Reported-by: Junyao Zhao <junzhao@redhat.com>
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
>
> diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trac=
e-cmd/include/private/trace-cmd-private.h
> index f2cf8dc8..2d14ed7a 100644
> --- a/lib/trace-cmd/include/private/trace-cmd-private.h
> +++ b/lib/trace-cmd/include/private/trace-cmd-private.h
> @@ -370,7 +370,7 @@ enum {
>  void tracecmd_free_recorder(struct tracecmd_recorder *recorder);
>  struct tracecmd_recorder *tracecmd_create_recorder(const char *file, int=
 cpu, unsigned flags);
>  struct tracecmd_recorder *tracecmd_create_recorder_fd(int fd, int cpu, u=
nsigned flags);
> -struct tracecmd_recorder *tracecmd_create_recorder_virt(const char *file=
, int cpu, unsigned flags, int trace_fd);
> +struct tracecmd_recorder *tracecmd_create_recorder_virt(const char *file=
, int cpu, unsigned flags, int trace_fd, int maxkb);
>  struct tracecmd_recorder *tracecmd_create_recorder_maxkb(const char *fil=
e, int cpu, unsigned flags, int maxkb);
>  struct tracecmd_recorder *tracecmd_create_buffer_recorder_fd(int fd, int=
 cpu, unsigned flags, struct tracefs_instance *instance);
>  struct tracecmd_recorder *tracecmd_create_buffer_recorder(const char *fi=
le, int cpu, unsigned flags, struct tracefs_instance *instance);
> diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorde=
r.c
> index 0633edf5..44f245d5 100644
> --- a/lib/trace-cmd/trace-recorder.c
> +++ b/lib/trace-cmd/trace-recorder.c
> @@ -175,19 +175,46 @@ tracecmd_create_buffer_recorder_fd(int fd, int cpu,=
 unsigned flags, struct trace
>
>  static struct tracecmd_recorder *
>  __tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned fl=
ags,
> -                                 struct tracefs_instance *instance, int =
tfd)
> +                                 struct tracefs_instance *instance, int =
tfd, int maxkb)
>  {
>         struct tracecmd_recorder *recorder;
> -       int fd;
> +       int fd, fd2 =3D -1;
> +       char *file2;
>
> -       fd =3D open(file, O_WRONLY | O_CREAT | O_TRUNC | O_LARGEFILE, 064=
4);
> +       fd =3D open(file, O_RDWR | O_CREAT | O_TRUNC | O_LARGEFILE, 0644)=
;
>         if (fd < 0)
>                 return NULL;
>
> -       recorder =3D create_buffer_recorder_fd2(fd, -1, cpu, flags, insta=
nce, 0, tfd);
> +       if (maxkb) {
> +               int len =3D strlen(file);
> +
> +               file2 =3D malloc(len + 3);
> +               if (!file2)
> +                       return NULL;
> +
> +               sprintf(file2, "%s.1", file);
> +
> +               fd2 =3D open(file2, O_RDWR | O_CREAT | O_TRUNC | O_LARGEF=
ILE, 0644);
> +               if (fd2 < 0) {
> +                       close(fd);
> +                       unlink(file);
> +                       free(file2);
> +                       return NULL;
> +               }
> +       }
> +
> +       recorder =3D create_buffer_recorder_fd2(fd, fd2, cpu, flags, inst=
ance, maxkb, tfd);
>         if (!recorder) {
>                 close(fd);
>                 unlink(file);
> +               if (fd2 !=3D -1)
> +                       close(fd2);
> +       }
> +
> +       if (fd2 !=3D -1) {
> +               /* Unlink file2, we need to add everything to file at the=
 end */
> +               unlink(file2);
> +               free(file2);
>         }
>
>         return recorder;
> @@ -242,7 +269,7 @@ struct tracecmd_recorder *
>  tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flag=
s,
>                                 struct tracefs_instance *instance)
>  {
> -       return __tracecmd_create_buffer_recorder(file, cpu, flags, instan=
ce, -1);
> +       return __tracecmd_create_buffer_recorder(file, cpu, flags, instan=
ce, -1, 0);
>  }
>
>  /**
> @@ -255,9 +282,9 @@ tracecmd_create_buffer_recorder(const char *file, int=
 cpu, unsigned flags,
>   */
>  struct tracecmd_recorder *
>  tracecmd_create_recorder_virt(const char *file, int cpu, unsigned flags,
> -                             int trace_fd)
> +                             int trace_fd, int maxkb)
>  {
> -       return __tracecmd_create_buffer_recorder(file, cpu, flags, NULL, =
trace_fd);
> +       return __tracecmd_create_buffer_recorder(file, cpu, flags, NULL, =
trace_fd, maxkb);
>  }
>
>  struct tracecmd_recorder *tracecmd_create_recorder_fd(int fd, int cpu, u=
nsigned flags)
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 91cc90d4..69ea0cbd 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -3584,7 +3584,7 @@ create_recorder_instance(struct buffer_instance *in=
stance, const char *file, int
>                         flags |=3D TRACECMD_RECORD_NOBRASS;
>                 else if (!trace_vsock_can_splice_read())
>                         flags |=3D TRACECMD_RECORD_NOSPLICE;
> -               return tracecmd_create_recorder_virt(file, cpu, flags, fd=
);
> +               return tracecmd_create_recorder_virt(file, cpu, flags, fd=
, max_kb);
>         }
>
>         if (brass)
>

