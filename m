Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CA6148FF2
	for <linux-trace-devel@vger.kernel.org>; Thu, 22 Feb 2024 16:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708621100; cv=none; b=NRGT/BMRcU9jHUESbIhR/7HiiJPUXXHQHJ58Fx7+Um93mnsaEmc+no4NYtx4CbcHW5M2hW/QAEtDPROVPxhvf3KS6aV3ns2BmI7DuLx/5gNZnyP6dZUc0njDCyBtQh/FsCbrwB+PfE/Su5+zNwhnRw8Xjo7bqdQfsQ0R8Awuc70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708621100; c=relaxed/simple;
	bh=yTFKHwgPOmAqyvjKBy4l2gCuNj0tT+WvLgeIbUGPD9g=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aqYg5lhWOVKlJcrstUjHL76Aa+qKOg+Hb6G/JRcxA01v7PrLs43NClAq/XUygVCmRR0pU89wsqoxOVFFBMe6tlLYtI2LpoYfv6FPBAfxWh7iUSsoh8dPJC1t86XkAaAfX9yfcFUHbA1jBjmuwzbsBAb8/7pnp1holPdacsu4pRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788A3C433C7;
	Thu, 22 Feb 2024 16:58:19 +0000 (UTC)
Date: Thu, 22 Feb 2024 12:00:09 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Pierre Gondois <pierre.gondois@arm.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v6 1/2] trace-cmd split: Remove const to (struct
 handle_list).name
Message-ID: <20240222120009.05cd39c3@gandalf.local.home>
In-Reply-To: <20240222165418.2153026-1-pierre.gondois@arm.com>
References: <20240222165418.2153026-1-pierre.gondois@arm.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 22 Feb 2024 17:54:17 +0100
Pierre Gondois <pierre.gondois@arm.com> wrote:

> (struct handle_list).name was unnecessarily made const in:
> commit caa9eda091d6 ("trace-cmd split: Store instances in local list")
> 
> Remove it.
> Also fix bad indentation.
> 
> Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>

I figured I was guilty of that as well ;-)

Some of the code was probably copied and pasted from places that actually
needed it to be const.

-- Steve
