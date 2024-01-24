Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7120128368
	for <linux-trace-devel@vger.kernel.org>; Wed, 24 Jan 2024 17:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706118475; cv=none; b=AiDN2UGuC7WiJD9O5twNTux1/VUhkTPppccHGKWHzUOA6sAj1VX39rgRU461hDmsWME/IE2DmfpnaG5QRfCEuhZNctxkXGdg1izSZxpd/QMPgIqQA7oQh5sk66+RsVUHjWrTy2ih5g6y7kkd1sOTreipdQ+2zLdtFOx2mVP5yFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706118475; c=relaxed/simple;
	bh=7O7U67XC2/5xS3RU+VmK3kft0GyRWgda0g9TDe3Iz8w=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=aBssxSpMkK7RY45Ll96hRxhc5IrKhe/Sbf2rv2a91xy4Feh7cUHvN58nhZFmVUjRyn8jpLcYTS767NhxSsfaTilG1vrrauAXYDYcId9AB/UmV+S+J8dgWOdG4RDFoemoWcL6U2skP9StA4HNvWZqtknsWmibrHUZnSUYUc15MDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1CD2C433C7;
	Wed, 24 Jan 2024 17:47:54 +0000 (UTC)
Date: Wed, 24 Jan 2024 12:49:27 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Pierre Gondois <pierre.gondois@arm.com>
Subject: [PATCH v2] trace-cmd split: Initialize current in parse_file()
Message-ID: <20240124124927.3551e982@gandalf.local.home>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The code fix to correctly split start/end/time-window parameters removed
an initialization of "current" which can now fall out being uninitialized
and used for a later compare.

Found with valgrind.

Link: https://lore.kernel.org/linux-trace-devel/20240124122832.4e0b33b7@gandalf.local.home/

Fixes: 1439b8f518 ("trace-cmd split: Correctly split with start/end/time-window parameters")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
Changes since v1: https://lore.kernel.org/all/20240124123439.3441eb6f@gandalf.local.home/

 - rebase on the fixed commit, not in the middle of the other split patches

 tracecmd/trace-split.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index b6c056b5f34b..8c710da15f78 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -358,7 +358,7 @@ static unsigned long long parse_file(struct tracecmd_input *handle,
 				     enum split_types type,
 				     bool *end_reached)
 {
-	unsigned long long current;
+	unsigned long long current = 0;
 	struct tracecmd_output *ohandle;
 	struct cpu_data *cpu_data;
 	struct tep_record *record;
-- 
2.43.0

