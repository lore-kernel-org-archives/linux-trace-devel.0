Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3693B221271
	for <linux-trace-devel@vger.kernel.org>; Mon, 27 Oct 2025 20:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761598278; cv=none; b=or46kiyYxn3Y3J1E0bZ5l8Jq5MJlR+d/hMGPwu0+QzwYZDE8AsJG4i+nZXZNk6IZJ2X7EazuyE0yzq1eO9AWG1tcri6FrpktxgyOUfj0wyGTrbT2RpZAnYSC1AXTheMJa6yoJbS1B5R6GNGAw3awV0WS367Q/KE1LCg7xK2tbLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761598278; c=relaxed/simple;
	bh=DAbRrwOOMnnLQLS24fFqEvCdpFKymA/2o3nf8JlxxW0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=f9iCrD3sMR4PmTkRXd8NqJjTJs4nJHxIivszFsChxQr49Et/cfK5X4HW9/XtbdKkW01IxUTrIbGNWhoESJdzDzgsnjhbPYKMiFIv6AU+YApwMaalCMCKc5ZfreJGOJXh41sia7SDSRpUuK6HQ03eHsVImBs2pyNIxQMrf+qoiAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ksi7+XQF; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ksi7+XQF"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b3b27b50090so912385366b.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 27 Oct 2025 13:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761598273; x=1762203073; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QOU9ZqEXrRxHIABIaawWXNM9r1Ql5w2iMqaVD37JPPE=;
        b=ksi7+XQFLIN/FwIQkzqch/jt9gj5KFdeFrJqAUkInecsZw4etLCqdPN1Cbc/nnIhVr
         RoKn5LH4QxINd+BmiMFgOTxmqSIxI1XIBZRH/kmH11b22n6H3ggZXeR/USJFKxzIz7e4
         gZe4urDXpNLtL0RZ60Ifvk/nuSzIDP/5bbomAOUAbpZe5C8n2LAF90mEdtuKjsENomFW
         Lzi7dvqZbz25ib2IZ7nQc1UukFyc0Nl9vS5Uz7XEhPrXwp7n6OiTXzxOrx2d8vkEhHbJ
         kgDwaXn5cAfPmiNqschEEF9n7pPvKkrTIMzUUTFiNJsCeaRODDZhEnyobvQObn2VEqr4
         dHOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761598273; x=1762203073;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QOU9ZqEXrRxHIABIaawWXNM9r1Ql5w2iMqaVD37JPPE=;
        b=PfUenJFfDuqAQOw51IT4Rj8inuomKtpmqhneoHET1LS9Y8pavqi9wIEKLFm6nToPq6
         7KSn2XttkYLYhrWlVrMNvLJFUWw1Hc9ng73LAYbtuWsdKGUTEOEfhoauNARuR06yKapu
         1DP5iHEt4Uic8huHQ+HI97NQQ/V/Wprspko4NueY116OjsA6pBS3vNR5PGmEuk28f4Mb
         n3LeEDAjUy0wlzd7Zaap915PXJ3eV/0RyODXcxv+cQiy91RYfs97cX/r2sQS1exaoF5s
         Ss1vsk8t0fYfPTd26JWFW8PpzMV2Y7fEvaqE9nwu6s1pl4e6SJL2knuhQu44ap/mo7M/
         DSYQ==
X-Forwarded-Encrypted: i=1; AJvYcCUf6ehZun+8+OsG8WgHvGQuYbwAqMfib/hxDJiuvi/GuLdZXVnwmYsJNIRETjO4RXTmkgnR4M4xp5w4tM8QO8KtnA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxH9NIYYYJK0aFJDHul03MHYeXqwJKNOfaKahapm31S9c8Eda9R
	khlHyHjdj/lcKALQFynUokCjbEDnbZKfZPCGbS5D+b80+CmFCTlALBnLpgcZ2Q==
X-Gm-Gg: ASbGncvFouY9r+d/fMtvE3207bTogQxTUEPSFHZHUiAxJBP1KDKS9OQ0138ZsGalyRL
	rrjI9lHv2cwXyd0lQwG8pSpZAeJVezfXGusAoJlQOmgAvFkELPE3H5vYlDw+D4C+v9byBHDkdrf
	MEoxcmvmoOLs2MKcXzQoI44nQSSZWmXf+dkjOJUlNDF1KJVdyPg4Zi272i/n+I8Vb2vPYe0wnZ+
	eY5tA5Ye65BHTtAlLxdfS1kSBYNqUcqkmvON5U/xSVKKCwb74O4WtQis8HwXC38b7wlMc5X1H79
	WnsOFjSp/qZRhwJmdvEs/bid0GFetcCsvBA8VtUSkEpuwdxtduKSz5HNsM+gfFO1ABLbHEAM+qn
	HnZ5fSZFyFMStObH68UfTtvxzn1g5lzM29+JqGg6gk9PlinBZReLeeKjRunl/eLvV7tNMGgkGwy
	TpWsLYmjLHQyIgWiFmtIePvdif
X-Google-Smtp-Source: AGHT+IGBioxw94cXpxD0toSHSMHCWkn0OG8BL04x3sWYur4272ISeEkowFW04aZl9cYty9kOXKTExA==
X-Received: by 2002:a05:6402:42c7:b0:63c:103b:e1cf with SMTP id 4fb4d7f45d1cf-63ed76dd863mr1104031a12.0.1761598273096;
        Mon, 27 Oct 2025 13:51:13 -0700 (PDT)
Received: from [192.168.0.107] (62-73-72-56.ip.btc-net.bg. [62.73.72.56])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63e8036cdd4sm7220887a12.22.2025.10.27.13.51.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 13:51:11 -0700 (PDT)
Message-ID: <f6ec9f89-a161-e596-79bb-ec21aaa1047c@gmail.com>
Date: Mon, 27 Oct 2025 22:51:10 +0200
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] kernelshark: fix bug in the behavior of ksglwidget rubber
 band
Content-Language: en-US
To: Mircea Cirjaliu <mircea.cirjaliu@yahoo.com>,
 linux-trace-devel@vger.kernel.org
References: <5c7a78ce-b1f6-4396-982a-8b884242d8cc.ref@yahoo.com>
 <5c7a78ce-b1f6-4396-982a-8b884242d8cc@yahoo.com>
From: Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <5c7a78ce-b1f6-4396-982a-8b884242d8cc@yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Mircea,

Looks like this is indeed a bug, however it is hard to reproduce. I had 
to do a lot of right mouse button clicks before seeing this misbehavior 
to show up.

I will take the fix, but the patch itself heeds some additional work. 
See my comments in code below.

On 10/20/25 22:00, Mircea Cirjaliu wrote:
> Accidentally pressing right mouse button while dragging
> the range will cause the rubber band to behave abnormally.
> Improved the logic behind range dragging to account for this case.
> The state of the rubber band will be reset on right click.
> 
> Signed-off-by: Mircea Cirjaliu <mircea.cirjaliu@yahoo.com>
> ---
>   src/KsGLWidget.cpp | 40 +++++++++++++++++++++++++++-------------
>   src/KsGLWidget.hpp |  2 ++
>   2 files changed, 29 insertions(+), 13 deletions(-)
> 
> diff --git a/src/KsGLWidget.cpp b/src/KsGLWidget.cpp
> index 7f2001c..a2c1fc8 100644
> --- a/src/KsGLWidget.cpp
> +++ b/src/KsGLWidget.cpp
> @@ -190,6 +190,9 @@ void KsGLWidget::mousePressEvent(QMouseEvent *event)
>   	if (event->button() == Qt::LeftButton) {
>   		_posMousePress = _posInRange(event->pos().x());
>   		_rangeBoundInit(_posMousePress);
> +	} else if (event->button() == Qt::RightButton) {
> +		if (_rubberBand.isVisible())
> +			_rangeBoundCancel();
>   	}
>   }
>   
> @@ -262,8 +265,10 @@ void KsGLWidget::mouseMoveEvent(QMouseEvent *event)
>   	if (isEmpty())
>   		return;
>   
> -	if (_rubberBand.isVisible())
> -		_rangeBoundStretched(_posInRange(event->pos().x()));
> +	if (_rubberBand.isVisible()) {
> +		size_t posMouseRel = _posInRange(event->pos().x());
> +		_rangeBoundStretched(posMouseRel);
> +	}

I don't see the point in this change.

>   
>   	bin = event->pos().x() - _bin0Offset();
>   	getPlotInfo(event->pos(), &sd, &cpu, &pid);
> @@ -291,17 +296,20 @@ void KsGLWidget::mouseReleaseEvent(QMouseEvent *event)
>   		return;
>   

No need to pile if on top of another if here. Just start the function with

	if (isEmpty() || !_rubberBand.isVisible())
		return;

The rest may stay unchanged.

>   	if (event->button() == Qt::LeftButton) {
> -		size_t posMouseRel = _posInRange(event->pos().x());
> -		int min, max;
> -		if (_posMousePress < posMouseRel) {
> -			min = _posMousePress - _bin0Offset();
> -			max = posMouseRel - _bin0Offset();
> -		} else {
> -			max = _posMousePress - _bin0Offset();
> -			min = posMouseRel - _bin0Offset();
> -		}
> +		if (_rubberBand.isVisible()) {
> +			size_t posMouseRel = _posInRange(event->pos().x());
> +
> +			int min, max;
> +			if (_posMousePress < posMouseRel) {
> +				min = _posMousePress - _bin0Offset();
> +				max = posMouseRel - _bin0Offset();
> +			} else {
> +				max = _posMousePress - _bin0Offset();
> +				min = posMouseRel - _bin0Offset();
> +			}
>   
> -		_rangeChanged(min, max);
> +			_rangeChanged(min, max);
> +		}
>   	}
>   }
>   
> @@ -1132,7 +1140,7 @@ void KsGLWidget::_rangeChanged(int binMin, int binMax)
>   	/* The rubber band is no longer needed. Make it invisible. */
>   	_rubberBand.hide();
>   
> -	if ( (binMax - binMin) < 4) {
> +	if ((binMax - binMin) < 4) {
>   		/* Most likely this is an accidental click. Do nothing. */
>   		return;
>   	}
> @@ -1182,6 +1190,12 @@ void KsGLWidget::_rangeChanged(int binMin, int binMax)
>   	}
>   }
>   
> +void KsGLWidget::_rangeBoundCancel()
> +{
> +	/* The rubber band is no longer needed. Make it invisible. */
> +	_rubberBand.hide();
> +}
> +
What is the point in defining a function that does nothing but calling 
another function.

Thanks,
Yordan

>   int KsGLWidget::_posInRange(int x)
>   {
>   	int posX;
> diff --git a/src/KsGLWidget.hpp b/src/KsGLWidget.hpp
> index cafc70b..8fcac55 100644
> --- a/src/KsGLWidget.hpp
> +++ b/src/KsGLWidget.hpp
> @@ -315,6 +315,8 @@ private:
>   
>   	void _rangeChanged(int binMin, int binMax);
>   
> +	void _rangeBoundCancel();
> +
>   	bool _findAndSelect(QMouseEvent *event);
>   
>   	bool _find(int bin, int sd, int cpu, int pid,
