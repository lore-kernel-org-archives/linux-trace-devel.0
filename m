Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C95A158217
	for <linux-trace-devel@vger.kernel.org>; Thu, 16 May 2024 22:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715896981; cv=none; b=BkGPkKSrZMVaPKkrQf8Uz1GbYDgeQQz7PZ31vapOf6r/F+Q0B9CPRf5KRDGV3+cCo3bBzOHnkL65CZQd9x5AOiVBMzH3/UVKzd+iye89Zb+zl8aWK/v1tNZ+k7OmcyzpAVQ1LigTYfbLC2v6Cgi6DQVH2Lqayc28/fQXYV2jBng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715896981; c=relaxed/simple;
	bh=Johsgdvul5/eXV/RhJT9e1aBEO/A+yYgcp7D6RAgH7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rSJEvfFjm8g3CeWsgMDj+S9lCrCbfAH4NrMO+JhKTl276Xqge2EhL5lE67BqMiEFr2PqEP3azmrPi3SLqIJ918eBkkVYYrC+AJOD1NaHst/erJzPbaXGVoc6NYtj8KRQS8Q+nUHpOQNv0M0Z70SRQWm5uzGxPCsVxgSNjX32rWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89508C113CC;
	Thu, 16 May 2024 22:02:57 +0000 (UTC)
Date: Thu, 16 May 2024 18:02:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ian Rogers <irogers@google.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v1] libtraceevent: Avoid a simple asprintf case
Message-ID: <20240516180248.24aa5aeb@rorschach.local.home>
In-Reply-To: <20240509051317.1913001-1-irogers@google.com>
References: <20240509051317.1913001-1-irogers@google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  8 May 2024 22:13:17 -0700
Ian Rogers <irogers@google.com> wrote:

> Avoid an asprintf for the single character TEP_EVENT_NEWLINE and
> TEP_EVENT_DELIM case.

This states what the patch does, but omits why. What's wrong with
asprintf() here?

-- Steve
