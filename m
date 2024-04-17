Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2BF84D07
	for <linux-trace-devel@vger.kernel.org>; Wed, 17 Apr 2024 23:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713395142; cv=none; b=ntuo2rkwY29b+725HD4sqJMHls/0mxjdUJeCoZvMLHSeRnjbOR0b7KZ0b8BypqFlzxxmeGicu2ZFBT8MvyA5la+94Pe4+wsrh4B/t9qpDoF2WhRBx0HnWZXB+YUprMqj5HOXI/WIe0MI09Ro178LgXoQDKhVStl0SLh1HqgrcZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713395142; c=relaxed/simple;
	bh=fBb86KhS5ge9xP2N7rcr3iqt2CvhpNPoY2/0C8T8woY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e/4HQBuoCW0L3WxWB5uFEu1gPQ23Lfq5OWbCUyk4oh6ae20QunL8VDRhpNS5maUL9GX/FwRyVtuYsNwaruxSK/QtdBb+mdouOSq74sGma3m1C9ogNzu+iN0yzV0Vx/HWF0Qj29zCKnuXwAfMdrL8HnIhGIyjZMxdT+NThb2l+W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I3eY4Cwf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I3eY4Cwf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713395139;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fBb86KhS5ge9xP2N7rcr3iqt2CvhpNPoY2/0C8T8woY=;
	b=I3eY4CwfLXsPijNsGoQ14FehPP2Vi6n6LxewVmEjGN0IqyGIJMNwkb4yg8Ipw/3b00mnW4
	HrKoIXBdF4TiAdtkil2LBAHrMpKLIYsjTHOXo1FXounGPxQ3xIb2waPYO4HN3wffvc0ntV
	ZON5HH+FcsXx2IFIM2i1CFXx0hY4+lU=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-398-zNwgG6PVNI-2wiVhKUVFiQ-1; Wed, 17 Apr 2024 19:05:38 -0400
X-MC-Unique: zNwgG6PVNI-2wiVhKUVFiQ-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2d86a38bb94so2138951fa.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Apr 2024 16:05:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713395136; x=1713999936;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fBb86KhS5ge9xP2N7rcr3iqt2CvhpNPoY2/0C8T8woY=;
        b=JYT0g3+oWa+/ARP8EiSXRnGNGIJVT4ciua6IePni5m4HR6cfZt7/x63d4ecJ4qb48V
         2jx1S1Xd6EUDw7CpZOXE7qXaI3RWvBdeOuP3kpM9bOEYeUXBeEqsumtFj5S7Oti6uXb8
         Co6/XLwKmBFRfwwCQvjcjs1BpmZ4aTV5GOb1dxqrOH5wuJNbo95MFkJu39RsDM4czq12
         7OgDoVotOMoohUDKUftjEvlTS8N7HtRfR7HUspBbocUSmAbnVZeczMNLqnRvKJrva9wP
         JIzJ4IN2E1a9pADJutgsGZBOE3rluFAI0xOcHHFnFLlHTwF2aD+3PX/SX+xd7yxN3MCX
         7jAQ==
X-Gm-Message-State: AOJu0YwhGghksQV1MuhE0yd2Zu9keLnHf2J9n5XM8Ef8cyGCZEZN/v+K
	nnWA08sS6jq97KK88d3UJ4Dzz9mCKutnm4c8Iay36Q6Ob4QqIO4grHpkVspugRAKIVgycJD/B17
	52lI7nFqTcuddX+eE0jcJa/MoPrubF5ggEYs/LSUaOCaLSAkDOaz04FFIVAMAShOvKd/QBf/Azj
	knzF08wkFYIMtpeXyS78pw/grmLnmPg7k8gSGW9SVV1Q4=
X-Received: by 2002:a2e:998c:0:b0:2db:381a:bf6e with SMTP id w12-20020a2e998c000000b002db381abf6emr364675lji.16.1713395136609;
        Wed, 17 Apr 2024 16:05:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHs7b20tBzV26oVsms4k3g/ARrnamIyp/RNKzzrOzfI1jVRqa6E0xkuDW3clTyJlzK2VV/9GdKHClS/jc3vZzM=
X-Received: by 2002:a2e:998c:0:b0:2db:381a:bf6e with SMTP id
 w12-20020a2e998c000000b002db381abf6emr364665lji.16.1713395136308; Wed, 17 Apr
 2024 16:05:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAK-6q+iAuLM35C1kZbDpS4E_61vC9A1mTpJb+nzhfX5DPUQkGg@mail.gmail.com>
 <46859f90-bdf6-4502-bf6a-4add6dad3668@efficios.com> <CAK-6q+h=5LcjtTxJ0i3BcaVZRGfyWpQJy6Htxjh_zFfOgUpwfA@mail.gmail.com>
In-Reply-To: <CAK-6q+h=5LcjtTxJ0i3BcaVZRGfyWpQJy6Htxjh_zFfOgUpwfA@mail.gmail.com>
From: Alexander Aring <aahringo@redhat.com>
Date: Wed, 17 Apr 2024 19:05:25 -0400
Message-ID: <CAK-6q+jAQFco6zMS8EKr3RgwmZ+bP4pg-aD_j7+Qi-oEoPXJuQ@mail.gmail.com>
Subject: Re: RFC: using NIC DMA ring as tracing buffer?
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-trace-devel@vger.kernel.org, linux-trace-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Apr 17, 2024 at 6:51=E2=80=AFPM Alexander Aring <aahringo@redhat.co=
m> wrote:
>
> Hi Mathieu,
>
> On Tue, Apr 16, 2024 at 10:49=E2=80=AFAM Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
> >
> > On 2024-04-16 10:41, Alexander Aring wrote:
> > > Hi all,
> > >
> > > I have an idea about using the DMA rings of a networking card as a
> > > tracing buffer.
> >
> > The first thing I'd be worried about is overhead caused by
> > false-sharing if you trace a large SMP/many-core system all
> > into the same global NIC buffer. The cache lines will bounce
> > left and right which is bad performance-wise.
> >
>
> modern NICs have several tx and rx dma rings. There is an ethtool
> command to query the number:
>
> sudo ethtool -g $IFACE
>
> so it depends on the hardware if you can pin one or more rings on a
> per-cpu buffer basis.
>
> I hope that somehow helps to make this idea less worrisome.
>

What I can think about that makes it worrisome is NUMA. In case of an
E-PCI connected NIC, the NICs buffer associated with a core needs to
be in the same NUMA node. You need to set up your system right, even
with 2 nics or more, to make it work "better".

- Alex

