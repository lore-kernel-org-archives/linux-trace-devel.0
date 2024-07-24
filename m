Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261F515ECF6;
	Wed, 24 Jul 2024 19:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721849567; cv=none; b=ENJaTYOdzDTbxtYxVB14FEDmWXRB/ZwDvDuBUBbF6xH1RAfgvq25ELlNs1naL2tbh2FEtyaAx9zvWEoaFiosBQjLBul3LU/Zl+mJj2L7poT8H/1msWe/AvDXIYiZKPjh4Pw+ZywfLFMEBIaUlCqN8Kanw+ul6BEB/IrsLRVnSuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721849567; c=relaxed/simple;
	bh=5fCfN4xTLZCH+Rs+N04VKgu4GNKojk5vc93AXxtwTNc=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=cxVwztKfohF56AfZg+YJzljRhdTbtwI9tWOZOVV3lNmghx3a0waCfQnRnM+OD4oVWHXecKBexSZLvEK8m1hfw0F78A4MX9E6m/lvTZkwH5K8kremjWBqlvTk1w2Ly3PEGNYghbRMtmXITzUwJk1IOi11W+uSAi5A+Gh7J+oIDAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5E4C32781;
	Wed, 24 Jul 2024 19:32:46 +0000 (UTC)
Date: Wed, 24 Jul 2024 15:33:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>, LKML
 <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] libtraceevent 1.8.3
Message-ID: <20240724153305.48d928b4@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

We are pleased to announce: libtraceevent: 1.8.3

Changes since 1.8.2

- Add "make meson", "make meson_install", and "make meson_docs"
  This will build the code using meson and not use the Makefiles.

- Include libgen.h for basename() for compiling utest with musl

- Various Meson build fixes

- Fix tests to run on big endian achitectures

- Have single quotes represent characters in the print-fmt.
  When used as a printf parameter, the code was breaking as it
  was treating it as as string and not a character.

- Fix a few memory leaks

- Avoid asprintf() usage that caused noticeable overhead.

- Fix some file descriptor leaks.

- Have the unit test fail (return error) if any of the tests fail

- Fix passing an address of a local variable out of a function

- Fix a double free.

git repo: git://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git
tarball: https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/snapshot/libtraceevent-1.8.3.tar.gz

-- Steve
