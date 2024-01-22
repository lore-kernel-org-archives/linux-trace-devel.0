Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C68E658134
	for <linux-trace-devel@vger.kernel.org>; Mon, 22 Jan 2024 16:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705941837; cv=none; b=K1qrEJcG7mxGmb+JN41Muo42i49k+RrPbAYbOmqSoYTsH1DhaCbRaAV7oTMerJkt50gUZppe4sPFbwMadmP0ycwrLJ2NezQYoyP3jciF+Lkk4lguKFa9EkOitdNzKNGAhMs6CxqlAoZrjfraKU5pNgAbZ5Ea2sqlWsRFeHkM07M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705941837; c=relaxed/simple;
	bh=O0aJtubHwTKtvUEesfi/qkz2utlbGFMLULZ2UKkV6Mo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Fuq0sGAeEbnIQiSgIj0GrFWaZk4ELZQWFz9WYgNzXDKzFqEir4Ilca3VG6TfC/7X60sp1XJkOF+sdVgwYQJ80vk09e/Py1eaVgpRgJNxBicFWxD3sb5p89KOUbGtDprFM6zMjJq3inaFa2x5Fh9pV8l1sIqLgjPpoYhDi7jn0QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BF7CE1474;
	Mon, 22 Jan 2024 08:44:41 -0800 (PST)
Received: from e126645.nice.arm.com (e126645.nice.arm.com [10.34.100.129])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0AC123F5A1;
	Mon, 22 Jan 2024 08:43:54 -0800 (PST)
From: Pierre Gondois <pierre.gondois@arm.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Pierre Gondois <pierre.gondois@arm.com>
Subject: [PATCH v2 7/7] trace-cmd split: Update usage
Date: Mon, 22 Jan 2024 17:43:36 +0100
Message-Id: <20240122164336.167256-8-pierre.gondois@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240122164336.167256-1-pierre.gondois@arm.com>
References: <20240122164336.167256-1-pierre.gondois@arm.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update usage for 'trace-cmd split' command:
- Add missing description of -i/-C options
- Add description of the newly enabled -B/--top options

Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
---
 tracecmd/trace-usage.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 6944a2c7..e5b84733 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -304,13 +304,20 @@ static struct usage_help usage_help[] = {
 	{
 		"split",
 		"parse a trace.dat file into smaller file(s)",
-		" %s split [options] -o file [start [end]]\n"
+		" %s split [-i file] [options] [-B buffer] [--top[=name]] -o file [start [end]]\n"
 		"          -o output file to write to (file.1, file.2, etc)\n"
 		"          -s n  split file up by n seconds\n"
 		"          -m n  split file up by n milliseconds\n"
 		"          -u n  split file up by n microseconds\n"
 		"          -e n  split file up by n events\n"
 		"          -p n  split file up by n pages\n"
+		"          -C n  select CPU n\n"
+		"          -B buffer    keep buffer in resulting .dat file\n"
+		"                       The first buffer specified will be the top buffer.\n"
+		"                       Use --top option to select the top buffer of the input\n"
+		"                       .dat file.\n"
+		"          --top[=name] keep top buffer in resulting .dat file.\n"
+		"                       If specified, rename the top buffer to TOP.\n"
 		"          -r    repeat from start to end\n"
 		"          -c    per cpu, that is -p 2 will be 2 pages for each CPU\n"
 		"          if option is specified, it will split the file\n"
-- 
2.25.1

