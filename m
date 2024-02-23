Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E6014CAC3
	for <linux-trace-devel@vger.kernel.org>; Fri, 23 Feb 2024 22:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708728493; cv=none; b=tVvg7PZfoWZe4D57IwbpTJN4W4b/grao0GgLPTBJz9rGxUVSzMEis3DLtpGWMNjMEYgTB957uW+C5JKiX7sWC3wy48hxIcT3fRvMX5czq32gUDYGMIO6Jyt/s5n+du+7qlyEeCnZLYcY+zkkOoxBfcWxucxlWWGpMaQppsjZb2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708728493; c=relaxed/simple;
	bh=7oQFi2aDPtqsfFGhrzcA8tx58mBQp+C1+m6xeTGo0Dg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l7VkyQawKJazDcSzrzJgP6qbCC6Sj0BVdIPOZd//DKqej+ab05zS9/pQ7oTqHad7M1f397nxSwYHi803GFjn2Qql2vnioWtgFWOR0ymf0rMx9EC8OX0l/9g6YEUETlTJP/fQXCUAzYo1YVgKb1J1Vse+hnmGx9GMCXkNrIrnpgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tJeU24ip; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tJeU24ip"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-33d9d43a1eeso902322f8f.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 23 Feb 2024 14:48:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708728490; x=1709333290; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eDjTBZTXYbVkClWOmkr+7yz8ociL0dieL16xymYPNBI=;
        b=tJeU24ipifiOKxMf9BGscdZNrlDCnyGiy+pbZSKj3duPByZqBL2CanV378h5+HHZWi
         q0+7J8nsrB+Gj0j2vHrUeShTCzOkvfpyaxBbZAR9ojBBYVJwsnSkHhb65rgJGKlDnq5Z
         gs0+pvJGZdx1iBQndvVEWmHeR3WA9cOWNtZw2ZiMF4e3rcCet8lodV26WcZG3cZCArlu
         1C1ZZqR0hXKHezn6UrGs97GOx2qyV15PRB2pKX45wULkLoXXslZArbqH/8O7Og20f/0Z
         71JUFxxppllWrL51kpV1T4spmyMLikRbzcMhC2UsM4HKJm+KfJHPRCh4MLHENdcfdSTJ
         N8Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708728490; x=1709333290;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eDjTBZTXYbVkClWOmkr+7yz8ociL0dieL16xymYPNBI=;
        b=CtPR1rhW7Mhp286PInsfwN0aisLSV/4O6nQlMjmKjsedsWHHQxcp+EcvcBWavD8L6L
         0HXwKo4/gZ0pSzf13l/Nl9WSlpn1ckEw9/Zhj/cJ8R3yi5+yWrweIvgwgoxNBZvP4tY3
         4USosq5Z/qf/Ha3Hxm0/Co3mknl9y5YVmxVz2irwwlj6rHq+1qcErxFQRBpmna1ZZUko
         cxFZafCClMRch0B3HqOeWUjqnZn6R3HaP6ZSyEEUh2Zpvsf+39KJW3Ww16zf+MGJfK3W
         xNUdOYyxUczJ9CWxEpJiPvmmZykT7BjRttOEjHKJwHRCGxIehhLKWYlmUoIr3x/Wn1LN
         DYsQ==
X-Gm-Message-State: AOJu0YxBlCcLqQfy16fUAoBt4K2oMtUgdDnhdjHK7XQzuTVnhxdS7p8W
	ziE0UtqhGePL5s/cixmDqwl+d5DZB8vcIifOYQGhG0Sb4tjihUyCN1n/CzsGgYX8I+q/Ng9iAHP
	NMw==
X-Google-Smtp-Source: AGHT+IHA6IRJJvE9fSs2ExzTZTtTHhnp/uJEwmxd2T1kUnEMW+u1cniTA8U3X2juK3/elVQsnD5r5g==
X-Received: by 2002:adf:e703:0:b0:33d:3566:b5c5 with SMTP id c3-20020adfe703000000b0033d3566b5c5mr825822wrm.7.1708728489680;
        Fri, 23 Feb 2024 14:48:09 -0800 (PST)
Received: from google.com (44.232.78.34.bc.googleusercontent.com. [34.78.232.44])
        by smtp.gmail.com with ESMTPSA id j3-20020a056000124300b0033cf5094fcesm4270359wrx.36.2024.02.23.14.48.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Feb 2024 14:48:09 -0800 (PST)
Date: Fri, 23 Feb 2024 22:48:05 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2] libtracefs: Update trace_buffer_meta
Message-ID: <ZdkgpdtMthOOITx2@google.com>
References: <20240129143122.2149432-1-vdonnefort@google.com>
 <20240223163915.6a714b56@gandalf.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223163915.6a714b56@gandalf.local.home>

On Fri, Feb 23, 2024 at 04:39:15PM -0500, Steven Rostedt wrote:
> On Mon, 29 Jan 2024 14:31:22 +0000
> Vincent Donnefort <vdonnefort@google.com> wrote:
> 
> > The current version for struct trace_buffer_meta is taken from a work in
> > progress Linux patch series. Update it.
> > 
> >
> 
> Since your code is now in linux-next, care to send an updated version of
> this patch?

Looking at the last version of trace_mmap.h the v2 looks already up-to-date. But
I sent a v3 adding the comments.

--
Vincent

> 
> I'll still keep it disabled in the library until it gets released in a
> stable tag (v6.9).
> 
> -- Steve
