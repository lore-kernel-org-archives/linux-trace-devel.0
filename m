Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0157C5D90A
	for <linux-trace-devel@vger.kernel.org>; Fri, 23 Feb 2024 21:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708724243; cv=none; b=cBHiS5MQULy0wRG5yiwcZ4yWFfa55cWUlzBMYOTV0iPre+HM9+Cybr+lS9AvyT69x9XprmPC/JsXKucRfcmnDZrH4Xm+4Kk36BJx+fqouOff5jRc/LuosrKS+0JDWZUfr2xoAhGpAdIqS16c0VJfBlJh9i2bNA46MaAQ6pAppvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708724243; c=relaxed/simple;
	bh=y9Z/3kwdiDSj93fThvNrjBw+un7NijX7+OQFVk8Eoso=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HIfyy3zESGng4zI/cogzJiz6b9mkRQVqcwnoJS4Ov+5orIJ4SSwGb1n2NvYAfCxDp44VhXzrhupLUi+m+F4p8m8AdPjUGFdPm1yQFanpVYCLdqMUuvCurlyKIj2OSfV5kcwnPEJ89GZfGsO4eVUKhzbptBblGMkYBXUVwvQa82c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7AFC433F1;
	Fri, 23 Feb 2024 21:37:22 +0000 (UTC)
Date: Fri, 23 Feb 2024 16:39:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2] libtracefs: Update trace_buffer_meta
Message-ID: <20240223163915.6a714b56@gandalf.local.home>
In-Reply-To: <20240129143122.2149432-1-vdonnefort@google.com>
References: <20240129143122.2149432-1-vdonnefort@google.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 29 Jan 2024 14:31:22 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:

> The current version for struct trace_buffer_meta is taken from a work in
> progress Linux patch series. Update it.
> 
>

Since your code is now in linux-next, care to send an updated version of
this patch?

I'll still keep it disabled in the library until it gets released in a
stable tag (v6.9).

-- Steve
