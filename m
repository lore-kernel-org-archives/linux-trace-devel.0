Received: from mail.nearlyone.de (mail.nearlyone.de [49.12.199.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB14188014
	for <linux-trace-devel@vger.kernel.org>; Tue, 30 Jul 2024 16:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.199.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357521; cv=none; b=dYr3o4GSJMICrDubDUEQVCZQVoq5frBQ79qYalcBbxCvN8/Q9UG/9XDY2dh5zFt+PgrQj8sC+TXLoZxdqW0GEe3POJ3c0WykZrt3e3vv+DDoZsH44cM0Fy4fg746episNdwYDkohMe/zVHkd/HIvZQpo22y6llLcQUq9g5E758U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357521; c=relaxed/simple;
	bh=DSZrxeVKPmQz37bjGVRp4sKGpHfNzpsMN5gqgCtIC3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iiqmpTNbhtbuKdE2/q6qGeol0Co5b6BOZsDXsUhHGwfCuyKljFIlA/lDDFjwZWcmf8hKI5qcyKvGuxJWYhQGKLG5xO2uowwLpuf7uI1RZDudbH8ZTCM8WSrNLiQzXuw9zktO4HKiHCbPDtHAwOEcFAK8ANkmhPQXtfvF7BqP+qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=monom.org; spf=pass smtp.mailfrom=monom.org; dkim=pass (2048-bit key) header.d=monom.org header.i=@monom.org header.b=NmPrVEyR; arc=none smtp.client-ip=49.12.199.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=monom.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=monom.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=monom.org header.i=@monom.org header.b="NmPrVEyR"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 7FC76DACB4;
	Tue, 30 Jul 2024 18:38:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=monom.org; s=dkim;
	t=1722357516; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=x1tnjDc1LIwz3VJTB91KO802+ERRccrqVdEkLGk//UQ=;
	b=NmPrVEyR07cmcTm6MP0v04w1wzm3+xo6/F1wtgPtq9TxbFCR3FCNdK9Jh3OY5Mtay3DsGQ
	X2T4FFHks5+a+IdkQBe+YS9dTLay4ku2t20BFW4GA+lmQkSfLzxt4BrVmNEVS4F+z5NcwH
	zapQk/vazIQaC7FEzbqCS/q4S/S5/V2hP00504Vy3/YVE7zOlMwVX8GBNjCB1fkJi8dnWu
	jvGo0+HlO9AJFHQaU0rrijRiveTK1868XsvyFh9qDEsKlUA0bNCCaQAf8iN/hRFTXL3tGF
	VYfQYPidFi1CeAiKVPfUy2VNlYHChk8wAqKiZjTeol6otvoWTBA7gIrHCJqLpg==
Date: Tue, 30 Jul 2024 18:38:35 +0200
From: Daniel Wagner <wagi@monom.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] trace-cmd: Add meson build targets to Makefile
Message-ID: <vuazfejmnm3imi6crifwz3mrv2szwje6ijjz4kj3yhadvjcrfd@a42xh42uoofi>
References: <20240724154545.7a536a44@gandalf.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240724154545.7a536a44@gandalf.local.home>
X-Last-TLS-Session-Version: TLSv1.3

On Wed, Jul 24, 2024 at 03:45:45PM GMT, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Add make targets for building with meson:
> 
>   make meson
>   make meson_install
>   make meson_docs
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Reviewed-by: Daniel Wagner <dwagner@suse.de>
