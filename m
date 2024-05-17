Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0419112F58C;
	Fri, 17 May 2024 19:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715972811; cv=none; b=RwVuw4CMwFhyEaQp1Goo9mMItPrwum/xCvSN0HC6RPZiCOkL4FqeJ3BCvJDYlDCrXXW25uPP51FpsLpF3IBbkSc90NnI1dSUu/EPl6Zku8U2ivzSANzywGwjBgUNo0/oE1JBVBrxhSQyQkKR+thj7M7N7hylURsfVt4HRtzfFMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715972811; c=relaxed/simple;
	bh=ztCk9m3PZEFy8Ni9JRWKYP+lbvo/anyaGM9//v+pi+g=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bhLYbdKY+Tuie4YySzUFaEzAzcYqIWvyrXY31ZqLBRMqJpI7QYjI/5gPANTJw16x0gD/UGCkvCocy8kEjYcffzbO6W6/vypkquatgO5PnIH1cbEeW6MPU0OLLmQ1q9eQCmDd81HUkhaTX1xCIGyF24x+o0KdtsqcMf7VoCWwplQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1757C2BD10;
	Fri, 17 May 2024 19:06:49 +0000 (UTC)
Date: Fri, 17 May 2024 15:07:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: John Kacur <jkacur@redhat.com>
Cc: Daniel Bristot de Oliveria <bristot@kernel.org>, lkml
 <linux-kernel@vger.kernel.org>, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4] rtla: Documentation: Fix -t, --trace
Message-ID: <20240517150721.4ab2537e@gandalf.local.home>
In-Reply-To: <20240516143121.12614-1-jkacur@redhat.com>
References: <20240516143121.12614-1-jkacur@redhat.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


John,

FYI, please email linux-trace-kernel@vger.kernel.org instead of
linux-trace-devel, as this code lives in the kernel proper, and the
patchwork attached to linux-trace-devel doesn't follow updates that go
there.

The patchwork for linux-trace-kernel will automatically update patches that
are applied to Linus's tree.

Thanks,

-- Steve


On Thu, 16 May 2024 10:31:21 -0400
John Kacur <jkacur@redhat.com> wrote:

> Move -t, --trace from common_options.rst to
> common_osnoise_options.rst and
> common_timerlat_options.rst

> 
> so that it will appear in the man pages
> 
> rtla-timerlat-hist.1
> rtla-timerlat-top.1
> rtla-osnoise-hist.1
> rtla-osnoise-top.1
> 
> Remove the equals ('=') sign and add a space.
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>
