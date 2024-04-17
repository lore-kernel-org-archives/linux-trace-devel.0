Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549A822F19
	for <linux-trace-devel@vger.kernel.org>; Wed, 17 Apr 2024 22:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713394304; cv=none; b=CyhWHXrQieXEV1MAneNlwrRTcSkjqqqv6SJ/vTE+oAXG3lpP1koEi+Qyd8Y2NE3SIU51KG5PlQouNhV36PovU13gP8mDerZnocCdkhstZoOIZBMINtCv8bnNulWkpWbvHoNxAMbOgIG2SQ4RObGf/qIXHlHyYWk3GyEfB5l5IZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713394304; c=relaxed/simple;
	bh=2Ut7vrdU1KkF7HvetF9BGNL5+pUX9QgjV74YQtx6xMw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D0nfAJ9ps5xgbOBNLdF71ikt6IVoRVRoiPQWsuaD5jElCAztGULnUBLxEhlndd6CWXdWXjtyDTBGebyP6XbrQbv8LUCl9v/2CM5CbzdTCW5ciH7sX67Gju3TLTjf4q0uHGUJEs9/6WiXddgMBV/sO0nK2lvTc0HKK38deAsIYZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NjyGmBBa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NjyGmBBa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713394301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2Ut7vrdU1KkF7HvetF9BGNL5+pUX9QgjV74YQtx6xMw=;
	b=NjyGmBBaMuFpA+6mAHFW54mvX45Yi+ZAZvB9TXRkZQtljU6G/mPzJL9SM+kBzzSs9F1u5C
	9XYHp9lKZLZmR1B5szWsN2NNfFUFqj8EoV0k/J3UDEKO/xBo6W6hSbaiHgQPi9Tvy7HF8s
	XF27vfGq5ija8lDWXiSVxRFZ6SeqWzY=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-370-wpzIy7NpMi6HB-Kl1kJNnw-1; Wed, 17 Apr 2024 18:51:39 -0400
X-MC-Unique: wpzIy7NpMi6HB-Kl1kJNnw-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2d880c1c295so2363541fa.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Apr 2024 15:51:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713394298; x=1713999098;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2Ut7vrdU1KkF7HvetF9BGNL5+pUX9QgjV74YQtx6xMw=;
        b=E4f+jSHhlMkpBvtKj6B1BJHQYERNURXSEfgjUeWFmWgGuvgBMC0W/NXLnhG9Jhg7Ct
         MW/aMDv7dCU5I55NyQP0ECml8YjexQtfcSmVvrLNF3Pgz7Ynd9XwiJUDBMb4/DCexxQz
         yj/MqYoz0f0hbwe+fYi0yDjM4G7UWTVMVv77k/TTvLn3bgD2QbktDWn9a6ICOSbvyIBf
         zmFQbrHbsp5L+kWJsv2Pow8tP+cLWZG7Z2KI59hmvZJvambESb1wslBc7a0IwcEbgYk0
         9GpcQwVn36blbBbhngt5j7AKFXSXEGBkh1MQg7vtuKEVLEGV4cC44ngzfIPA5WpAlvMp
         5bSA==
X-Gm-Message-State: AOJu0Yy8z7oGSnPsaLacLJaYuQrTqLWz/QGHXyRICqrhaHUxpdOZySX2
	gE+6BjzMZsCd0te8xELWRvnRJfx/FEFl8u5oL6/HrELc3sR20Qnvduaigc6zlv9lTAr0O7ZgvsY
	8nc5pikkLHzEgZkVfOYcW5NIPCjkvhUwXHYFzPDKdeVPPDc6yR32uqfi0DuBUT7Ahz8cu/MQB52
	VTf80KkQwMUftlUjM1LKCxUdfTxyP3EQX5TIsGYhxjAoc=
X-Received: by 2002:a2e:9ec3:0:b0:2d9:f818:1748 with SMTP id h3-20020a2e9ec3000000b002d9f8181748mr425249ljk.42.1713394298392;
        Wed, 17 Apr 2024 15:51:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGHv8V6pkZ2iXUQp2Arb4yz/S+ML9uU3wrjMvEQFONR31DH5IC+RmZi+qedV/6FFKY4pPdqkvhZ4BsuOSY/DC8=
X-Received: by 2002:a2e:9ec3:0:b0:2d9:f818:1748 with SMTP id
 h3-20020a2e9ec3000000b002d9f8181748mr425246ljk.42.1713394298043; Wed, 17 Apr
 2024 15:51:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAK-6q+iAuLM35C1kZbDpS4E_61vC9A1mTpJb+nzhfX5DPUQkGg@mail.gmail.com>
 <46859f90-bdf6-4502-bf6a-4add6dad3668@efficios.com>
In-Reply-To: <46859f90-bdf6-4502-bf6a-4add6dad3668@efficios.com>
From: Alexander Aring <aahringo@redhat.com>
Date: Wed, 17 Apr 2024 18:51:26 -0400
Message-ID: <CAK-6q+h=5LcjtTxJ0i3BcaVZRGfyWpQJy6Htxjh_zFfOgUpwfA@mail.gmail.com>
Subject: Re: RFC: using NIC DMA ring as tracing buffer?
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-trace-devel@vger.kernel.org, linux-trace-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Mathieu,

On Tue, Apr 16, 2024 at 10:49=E2=80=AFAM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> On 2024-04-16 10:41, Alexander Aring wrote:
> > Hi all,
> >
> > I have an idea about using the DMA rings of a networking card as a
> > tracing buffer.
>
> The first thing I'd be worried about is overhead caused by
> false-sharing if you trace a large SMP/many-core system all
> into the same global NIC buffer. The cache lines will bounce
> left and right which is bad performance-wise.
>

modern NICs have several tx and rx dma rings. There is an ethtool
command to query the number:

sudo ethtool -g $IFACE

so it depends on the hardware if you can pin one or more rings on a
per-cpu buffer basis.

I hope that somehow helps to make this idea less worrisome.

Thanks.

- Alex

