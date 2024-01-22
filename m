Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 172A958134
	for <linux-trace-devel@vger.kernel.org>; Mon, 22 Jan 2024 16:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705941833; cv=none; b=ehnnR9c9svImfsRPwSlaM/bjV/Kwip8sXWDVQ1OJlb8Kc5FDrYqnZw9kye6R3M2scOh6yiFLPg8UTDDHQEdWwJ0isdMha3YXmqZfmI9KNM3w2LJ2WpEEKFyfMWqzSbtwBZIHEijtPpodEYnWz/re9OzMafPoWW3F/Z7cN7C49EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705941833; c=relaxed/simple;
	bh=IU7bAzEMgeoTa4tdCS9uSJ4TLNUCHr4hgWm/1vOQvuI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=He90tPnp7ZDGNpI0aYrRhWhpb42i1nBZ3Z+OQLVal4cny1FFiwxkQ8PU0PPkKHXVW/YSTUGpaWWJ+fkz101k2aYCLzQV7IV0C+QxS9tDErM23DCIsBfsN6JujsdCa0EpdXkbRiyW3hEgXrHG+LxF9OIepLisDBKzDDIe4K+8tfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A53A9FEC;
	Mon, 22 Jan 2024 08:44:36 -0800 (PST)
Received: from e126645.nice.arm.com (e126645.nice.arm.com [10.34.100.129])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id DF97C3F5A1;
	Mon, 22 Jan 2024 08:43:49 -0800 (PST)
From: Pierre Gondois <pierre.gondois@arm.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Pierre Gondois <pierre.gondois@arm.com>
Subject: [PATCH v2 1/7] trace-cmd split: Small fixes
Date: Mon, 22 Jan 2024 17:43:30 +0100
Message-Id: <20240122164336.167256-2-pierre.gondois@arm.com>
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

Small fixes:
- Remove a useless assignment to 'current' variable.
- Fix returned type of parse_file()

Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
---
 tracecmd/trace-split.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index 4fda7813..6ccda2fc 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -347,11 +347,12 @@ static int parse_cpu(struct tracecmd_input *handle,
 	return 0;
 }
 
-static double parse_file(struct tracecmd_input *handle,
-			 const char *output_file,
-			 unsigned long long start,
-			 unsigned long long end, int percpu, int only_cpu,
-			 int count, enum split_types type)
+static unsigned long long parse_file(struct tracecmd_input *handle,
+				     const char *output_file,
+				     unsigned long long start,
+				     unsigned long long end, int percpu,
+				     int only_cpu, int count,
+				     enum split_types type)
 {
 	unsigned long long current;
 	struct tracecmd_output *ohandle;
@@ -551,7 +552,6 @@ void trace_split (int argc, char **argv)
 		strcat(output, ".1");
 	}
 
-	current = start_ns;
 	output_file = malloc(strlen(output) + 50);
 	if (!output_file)
 		die("Failed to allocate for %s", output);
-- 
2.25.1

