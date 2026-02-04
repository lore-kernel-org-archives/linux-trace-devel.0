Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FBC821B9F5
	for <linux-trace-devel@vger.kernel.org>; Wed,  4 Feb 2026 01:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770167762; cv=none; b=Wl97sf377fmjHMlmMC7CcS6nMdP/AMMnZrPoOmxhjsk5Fnpfu1ziJtcal0g1fmVBkip9XJqak19Lghly3ZrsYWn5mZY4oAEych1pgrkS12YVPDILXGNeGVK/3OJoIvYMpmUn2loA21SeoE1Hb+NVVshY+Fvj2Frs/SjaCXTmB/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770167762; c=relaxed/simple;
	bh=SPGO40fpJ3INZ6j2UFWLqH2DIQhuyFr2YIRn+R8Pe1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gCFZK2dDdi+xOikad4NRFMjYG+pmtsjLm/Zm/M8ZikBM3yKHkfoWLpTk2YHYdE5Qci1XGVQ1AOpaHKlOEyfD9HuVMI+Ap6AI9XP7+AwAdUWEkoA/n+iZIF716EkvS5v//KeMIdGMxpn3pdeQ4vlT9H8jRwXlG3go1RDqKUKflnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4CBBC19422;
	Wed,  4 Feb 2026 01:16:00 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.99.1)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1vnRVO-00000008xV4-3tjG;
	Tue, 03 Feb 2026 20:16:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/3] trace-cmd extract:
Date: Tue,  3 Feb 2026 20:14:52 -0500
Message-ID: <20260204011629.2135260-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Some updates for trace-cmd extract:

 - Always read the BTF file if it exists, as it isn't known if it is needed
   or not.

 - Do not delete the instance that it is extracting after it extracts the
   data. That was simply annoying.

 - Add a -K flag to trace-cmd record that doesn't reset anything before it
   starts recording.

Steven Rostedt (Google) (3):
  trace-cmd extract: Always read BTF file if available
  trace-cmd record: Add -K flag to keep current settings
  trace-cmd extract: Do not delete instances after extraction

 .../trace-cmd/trace-cmd-record.1.txt          |  7 +++-
 tracecmd/trace-record.c                       | 39 +++++++++++--------
 tracecmd/trace-usage.c                        |  1 +
 3 files changed, 30 insertions(+), 17 deletions(-)

-- 
2.51.0

